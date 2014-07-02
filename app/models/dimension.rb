class Dimension < ActiveRecord::Base
  belongs_to :film

  validates :width, numericality: { greater_than_or_equal_to: 0 }
  validates :length, numericality: { greater_than_or_equal_to: :width }
  
  scope :min_width, ->(width) { where("dimensions.width >= :min_width", min_width: width) }
  scope :min_length, ->(length) { where("dimensions.length >= :min_length", min_length: length) }
  scope :small, ->(cutoff) { where("dimensions.width*dimensions.length < ?", cutoff) }
  scope :large, ->(cutoff) { where("dimensions.width*dimensions.length >= ?", cutoff) }

  def area
    width*length/tenant.area_divisor
  end

  def tenant
    @tenant ||= film.tenant
  end
end
