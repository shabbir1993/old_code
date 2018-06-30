class SolderMeasurement < ApplicationRecord
  belongs_to :film

  validates :height1, numericality: { greater_than_or_equal_to: 0 }
  validates :height2, numericality: { greater_than_or_equal_to: 0 }

  def tenant
    @tenant ||= film.tenant
  end
end