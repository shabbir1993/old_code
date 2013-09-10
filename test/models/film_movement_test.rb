require 'test_helper'

describe FilmMovement do
  let(:film_movement) { FactoryGirl.build(:film_movement) }

  it "is ordered by created_at DESC by default" do
    earlier_movement = FactoryGirl.create(:film_movement, created_at: 1.hour.ago)
    film_movement.save!
    FilmMovement.first.must_equal film_movement
  end

  it "fg scope returns movements to fg" do
    film_movement.to = "fg"
    film_movement.save!
    FilmMovement.fg.must_include(film_movement)
  end

  it "fg scope does not return other phase film" do
    film_movement.to = "stock"
    film_movement.save!
    FilmMovement.fg.wont_include(film_movement)
  end
end
