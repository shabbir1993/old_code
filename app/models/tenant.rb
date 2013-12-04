class Tenant < ActiveRecord::Base
  attr_accessible :name, :time_zone
  cattr_accessor :current_id
end
