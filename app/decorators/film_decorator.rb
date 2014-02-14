class FilmDecorator < ApplicationDecorator

  def self.applicable_classes
    [Film]
  end

  def serial
    "#{master_film.serial}-#{division}"
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
    number_with_precision(super, precision: 2)
  end

  def utilization(search_width, search_length)
    unformatted = UtilizationCalculator.calculate_for_film(width, length, search_width, search_length)
    number_to_percentage(unformatted, precision: 2)
  end

  def second_utilization(search_width, search_length)
    unformatted = UtilizationCalculator.calculate_for_film(second_width, second_length, search_width, search_length)
    number_to_percentage(unformatted, precision: 2)
  end
end
