class Tenant < ActiveRecord::Base
  attr_accessible :name
  cattr_accessor :current_id
end
