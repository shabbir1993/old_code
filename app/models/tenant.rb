class Tenant < ActiveRecord::Base
  attr_accessible :name, :time_zone
  cattr_accessor :current_id, :current_area_divisor, :current_small_area_cutoff, :current_yield_multiplier

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
