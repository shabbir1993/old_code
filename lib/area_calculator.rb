module AreaCalculator
  def self.calculate(width, length, area_divisor)
    return width*length/area_divisor if width && length && area_divisor
    0
  end
end
