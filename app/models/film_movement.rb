require 'csv'

class FilmMovement < ActiveRecord::Base
  include PgSearch
  include Filterable

  attr_accessible :from_phase, :to_phase, :width, :length, :actor, :film_id, :film, :tenant_code

  belongs_to :film

  delegate :serial, :formula, :sales_order_code, to: :film
  
  # manual join as workaround for pg_search issue #88
  scope :exclude_deleted_films, -> { joins('INNER JOIN films ON films.id = film_movements.film_id').merge(Film.active) } 
  scope :sort_by_created_at, -> { order('film_movements.created_at DESC') }
  scope :created_at_before, ->(date) { where("created_at <= ?", Time.zone.parse(date)) } 
  scope :created_at_after, ->(date) { where("created_at >= ?", Time.zone.parse(date)) } 
  scope :to_phase, ->(phase) { where(to_phase: phase.downcase) } 
  scope :from_phase, ->(phase) { where(from_phase: phase.downcase) } 
  scope :tenant, ->(tenant_code) { where(tenant_code: tenant_code) }
  scope :text_search, ->(query) { reorder('').search(query) }

  pg_search_scope :search, 
    against: [:from_phase, :to_phase, :actor], 
    using: { tsearch: { prefix: true } },
    associated_against: { film: [:serial] }

  def datetime_display
    if created_at.year == Time.zone.today.year
      created_at.strftime("%e %b %R")
    else
      created_at.strftime("%F %R")
    end
  end

  def area
    AreaCalculator.calculate(width, length, tenant.area_divisor)
  end

  def self.to_csv(options = {})
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
