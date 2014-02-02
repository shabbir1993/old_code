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
end
