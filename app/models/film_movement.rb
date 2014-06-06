require 'csv'

class FilmMovement < ActiveRecord::Base
  include PgSearch
  include Filterable
  include Tenancy

  attr_accessible :from_phase, :to_phase, :width, :length, :actor, :film_id, :film, :tenant_code

  belongs_to :film

  delegate :serial, :formula, :sales_order_code, to: :film
  
  # manual join as workaround for pg_search issue #88
  scope :exclude_deleted_films, -> { joins('INNER JOIN films ON films.id = film_movements.film_id').merge(Film.active) } 
  scope :sort_by_created_at, -> { order('film_movements.created_at DESC') }
  scope :created_at_before, ->(date) { where("film_movements.created_at <= ?", date) } 
  scope :created_at_after, ->(date) { where("film_movements.created_at >= ?", date) } 
  scope :to_phase, ->(phase) { where(to_phase: phase.downcase) } 
  scope :from_phase, ->(phase) { where(from_phase: phase.downcase) } 
  scope :text_search, ->(query) { reorder('').search(query) }

  pg_search_scope :search, 
    against: [:from_phase, :to_phase, :actor], 
    using: { tsearch: { prefix: true } },
    associated_against: { film: [:serial] }

  def area
    return width*length/tenant.area_divisor if width && length && tenant.area_divisor
    0
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(Serial Formula Width Length Order User DateTime)
      all.each do |m|
        csv << [m.serial, m.formula, m.width, m.length, m.sales_order_code, m.created_at]
      end
    end
  end
end
