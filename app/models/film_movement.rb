class FilmMovement < ActiveRecord::Base
  attr_accessible :from_phase, :to_phase, :width, :length, :actor, :film_id, :film, :tenant_code

  belongs_to :film

  delegate :serial, :formula, :sales_order_code, to: :film
  
  scope :exclude_deleted_films, -> { joins('INNER JOIN films ON films.id = film_movements.film_id').where( films: { deleted: false }) } 
  scope :sort_by_created_at, -> { order('film_movements.created_at DESC') }
  scope :before_date, ->(date) { where("created_at <= ?", date) } 
  scope :after_date, ->(date) { where("created_at >= ?", date) } 

  def datetime_display
    if created_at.year == Time.zone.today.year
      created_at.strftime("%e %b %R")
    else
      created_at.strftime("%F %R")
    end
  end

  def self.search_date_range(start_date, end_date)
    movements = all
    if start_date.present?
      movements = movements.after_date(Time.zone.parse(start_date)) 
    end
    if end_date.present?
      movements = movements.before_date(Time.zone.parse(end_date))
    end
    movements
  end

  def area
    AreaCalculator.calculate(width, length, Tenant.current_area_divisor)
  end

  def self.fg_film_movements_to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Width Length Order User DateTime)
      all.each do |m|
        csv << [m.serial, m.formula, m.width, m.length, m.sales_order_code, m.created_at]
      end
    end
  end

  def tenant
    @tenant || Tenant.new(tenant_code)
  end
end