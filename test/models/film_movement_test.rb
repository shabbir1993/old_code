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

  it "scrap scope returns movements to scrap" do
    film_movement.to = "scrap"
    film_movement.save!
    FilmMovement.scrap.must_include(film_movement)
  end

  it "scrap scope does not return other phase film" do
    film_movement.to = "stock"
    film_movement.save!
    FilmMovement.scrap.wont_include(film_movement)
  end

  it "reserved scope includes movements of film with reserved_for" do
    film_movement.film.reserved_for = "something"
    film_movement.save!
    film_movement.film.save!
    FilmMovement.reserved.must_include(film_movement)
  end

  it "reserved scope does not include movements of films wtih nil reserved_for" do
    film_movement.film.reserved_for = nil
    film_movement.save!
    FilmMovement.reserved.wont_include(film_movement)
  end

  it "reserved scope does not include movements of films wtih empty reserved_for" do
    film_movement.film.reserved_for = ""
    film_movement.save!
    FilmMovement.reserved.wont_include(film_movement)
  end

  it "checkout scope includes movements of film to wip" do
    film_movement.to = "wip"
    film_movement.save!
    FilmMovement.checkout.must_include(film_movement)
  end
  
  it "checkout scope includes movements of film to fg" do
    film_movement.to = "fg"
    film_movement.save!
    FilmMovement.checkout.must_include(film_movement)
  end

  it "checkout scope does not include movements of film to other phases" do
    film_movement.to = "inspection"
    film_movement.save!
    FilmMovement.checkout.wont_include(film_movement)
  end
end
