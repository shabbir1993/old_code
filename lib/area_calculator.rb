module AreaCalculator
  def self.calculate(width, length, area_divisor)
    width*length/area_divisor if width && length && area_divisor
  end
end
