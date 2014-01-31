class Tenant < ActiveRecord::Base
  attr_accessible :name, :time_zone
  cattr_accessor :current_id, :current_area_divisor, :current_small_area_cutoff, :current_yield_multiplier

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def user(id)
    users.find_by_id(id)
  end

  def users
    User.where(tenant_id: current_id)
  end

  def new_user(*args)
    user = User.new(*args).tap do |u|
      u.tenant_id = current_id
    end
  end
end
