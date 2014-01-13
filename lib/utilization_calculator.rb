module UtilizationCalculator
  def self.calculate(width, length, custom_width, custom_length)
    if width && length && custom_width && custom_length && width >= custom_width && length >= custom_length
      100*(custom_width*custom_length)/(width*length)
    end
  end
end
