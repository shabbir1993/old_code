class FilmDecorator < ApplicationDecorator

  def self.applicable_classes
    [Film]
  end

  def phase_label_class
    case phase
    when "wip"
      "label-warning"
    when "fg"
      "label-success"
    else
      "label-danger"
    end
  end

  def moved_to
    if deleted?
      "deleted"
    else
      phase
    end
  end

  def moved?
    previous_changes.keys.include?("phase")
  end

  def area
    number_with_precision(super, precision: 2)
  end

  def second_area
    number_with_precision(AreaCalculator.calculate(second_width, second_length, tenant.area_divisor), precision: 2) if second_width && second_length
  end

  def has_second_dimensions?
    respond_to?(:second_width) && respond_to?(:second_length) && second_width && second_length
  end
end
