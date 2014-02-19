class Dimension < ActiveRecord::Base
  attr_accessible :width, :length
  belongs_to :film
  
  scope :min_width, ->(width) { where("dimensions.width >= :min_width", min_width: width) }
  scope :min_length, ->(length) { where("dimensions.length >= :min_length", min_length: length) }
  scope :small, ->(cutoff) { where("dimensions.width*dimensions.length < ?", cutoff) }
  scope :large, ->(cutoff) { where("dimensions.width*dimensions.length >= ?", cutoff) }

  def area
    AreaCalculator.calculate(width, length, tenant.area_divisor).round(2)
  end

  def tenant
    @tenant ||= film.tenant
  end
end
