require 'utilization_calculator'
require 'minitest/autorun'
require 'minitest/pride'

describe UtilizationCalculator do
  it "calculates the utilization of film" do
    UtilizationCalculator.calculate_for_film(80, 80, 64, 64).must_equal 64
  end
end
