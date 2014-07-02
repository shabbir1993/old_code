class Machine < ActiveRecord::Base
  include Tenancy

  validates :code, presence: true
  validates :yield_constant, presence: true
end
