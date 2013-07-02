class Film < ActiveRecord::Base
  attr_accessible :division, :phase, :width, :length, :custom_width, :custom_length, :reserved_for, :note, :sales_order_code, :customer, :shelf, :master_film_attributes

  belongs_to :master_film
  delegate :master_serial, :mix_mass, :film_code, :thinky_code, :machine_code, 
           :chemist_name, :operator_name, :effective_width, :effective_length, 
           :effective_area, :defect_count, to: :master_film

  accepts_nested_attributes_for :master_film

  after_initialize :set_division
  before_validation :set_phase

  validates :division, presence: true, 
                       uniqueness: { scope: :master_film_id }
  validates :master_film_id, presence: true
  validates :phase, presence: true
  validates :width, :length, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  scope :lamination, where(:phase => "lamination")
  scope :inspection, where(:phase => "inspection")
  scope :stock, where(:phase => "stock")
  scope :wip, where(:phase => "wip")
  scope :fg, where(:phase => "fg")
  scope :testing, where(:phase => "testing")
  scope :nc, where(:phase => "nc")
  scope :scrap, where(:phase => "scrap")

  def serial
    master_serial + "-" + division.to_s
  end

  def area
    width * length / 144 if width && length
  end

  def custom_area
    custom_width * custom_length / 144 if custom_width && custom_length
  end

  def utilization
    custom_area / area if custom_area && area
  end

  def valid_destinations
    case phase
    when "lamination"
      ["inspection"]
    when "inspection"
      %w{stock wip testing nc}
    when "stock"
      %w{wip testing nc}
    when "wip"
      %w{fg stock testing nc}
    when "fg"
      %w{wip stock testing nc}
    when "testing"
      %w{stock nc}
    when "nc"
      %w{scrap stock testing}
    when "scrap"
      %w{stock nc testing}
    else
      []
    end
  end

  def self.import(file)
    skip_callback(:initialize, :after, :set_division)
    skip_callback(:validation, :before, :set_phase)
    CSV.foreach(file.path, headers: true) do |row|
      record = Film.new(row.to_hash, without_protection: true)
      record.save!(validate: false)
    end
    set_callback(:initialize, :after, :set_division)
    set_callback(:validation, :before, :set_phase)
  end

private
  def set_division
    if new_record?
      self.division = sibling_films.any? ? sibling_films.pluck(:division).max + 1 : 1
    end
  end

  def set_phase
    if new_record?
      self.division == 1 ? self.phase = "lamination" : self.phase = "stock" 
    end
  end
  
  def sibling_films
    Film.where(master_film_id: master_film_id)
  end
end
