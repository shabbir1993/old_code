class Machine < ActiveRecord::Base
  attr_accessible :code 
  validates :code, presence: true
  validates :yield_constant, presence: true
end
