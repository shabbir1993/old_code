class Machine < ApplicationRecord
  include Tenancy

  validates :code, presence: true
  validates :yield_constant, presence: true
end
