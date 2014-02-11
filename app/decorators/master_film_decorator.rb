class MasterFilmDecorator < ApplicationDecorator

  def self.applicable_classes
    [MasterFilm]
  end

  def yield
    number_to_percentage(super, precision: 2)
  end
end
