class AvionicsJobOrder < ActiveRecord::Base
  has_many :avionics_job_dates, dependent: :destroy

  validates :serial, presence: true, uniqueness: true
end
