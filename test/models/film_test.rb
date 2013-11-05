require 'test_helper'

describe Film do
  let(:film) { FactoryGirl.build(:film) }

  it "sets deleted to false by default" do
    film.save!
    film.deleted.must_equal false
  end

  it "can change nested master film attributes" do
    film.save!
    film.update_attributes( master_film_attributes: { film_code: "new code" })
    film.master_film.film_code.must_equal "new code"
  end

  it "sets correct division on create" do
    first_film = FactoryGirl.create(:film, master_film_id: film.master_film_id)
    next_division = first_film.division + 1
    film.save!
    film.division.must_equal next_division
  end

  it "requires a phase" do
    film.phase = nil
    film.invalid?(:phase).must_equal true
  end

  it "destination sets phase" do
    film.destination = "new-phase"
    film.save!
    film.phase.must_equal "new-phase"
  end

  it "destination removes line item unless stock wip or fg" do
    film.line_item_id = 1
    film.destination = "nc"
    film.save!
    film.line_item_id.must_equal nil
  end

  describe "paper trail" do
    before { film.save! }

    it "creates a version with correct metadata when phase is updated" do
      initial_phase = film.phase
      film.update_attributes!(phase: "inspection")
      version = film.versions.last
      version.columns_changed.must_include "phase"
      version.phase_change.must_include initial_phase
      version.phase_change.must_include "inspection"
    end

    it "creates a version with correct metadata when shelf is updated" do
      film.update_attributes!(shelf: "N1")
      version = film.versions.last
      version.columns_changed.must_include "shelf"
    end

    it "creates a version with correct metadata when width is updated" do
      film.update_attributes!(width: 5)
      version = film.versions.last
      version.columns_changed.must_include "width"
    end

    it "creates a version with correct metadata when length is updated" do
      film.update_attributes!(length: 5)
      version = film.versions.last
      version.columns_changed.must_include "length"
    end

    it "creates a version with correct metadata when deleted is updated" do
      film.update_attributes!(deleted: true)
      version = film.versions.last
      version.columns_changed.must_include "deleted"
    end

    it "does not create a version when note is updated" do
      film.update_attributes!(note: "foobar")
      version = film.versions.last
      version.columns_changed.wont_include "note"
    end
  end

  it "effective dimensions also sets dimensions" do
    film.effective_width = 1
    film.effective_length = 2
    film.save!
    film.width.must_equal 1
    film.length.must_equal 2
    film.effective_width.must_equal 1
    film.effective_length.must_equal 2
  end

  it "valid_destinations must return an array" do
    film.valid_destinations.must_be_instance_of Array
  end

  describe "text search" do
    before do
      film.note = "foobar"
      film.shelf = "A1"
      film.save!
    end

    it "returns matching films" do
      Film.text_search("foobar A1").must_include film
    end

    it "does not return non-matching films" do
      Film.text_search("foobaz A1").wont_include film
    end
  end

  describe "given dimensions" do
    before do
      film.width = 60
      film.length = 60
    end

    it "search_dimensions finds it given correct params" do
      film.save!
      Film.search_dimensions(60, 60, 55, 65).must_include film
    end

    it "search_dimensions returns it given nil params" do
      film.save!
      Film.search_dimensions("", "", "", "").must_include film
    end

    it "search_dimensions returns it given correct partial params" do
      film.save!
      Film.search_dimensions(50, "", "", "").must_include film
    end

    it "search_dimensions wont find it it given incorrect params" do
      film.save!
      Film.search_dimensions(60, 60, 55, 59).wont_include film
    end
    
    it "search_dimensions does not return it given incorrect partial params" do
      film.save!
      Film.search_dimensions("", "", "", 55).wont_include film
    end

    it "calculates the correct area given dimensions" do
      film.area.must_equal 25
    end

    it "has nil area given nil length" do
      film.length = nil
      film.area.must_equal nil
    end

    it "has nil area given nil width" do
      film.width = nil
      film.area.must_equal nil
    end
  end

  it "returns sibling films including self" do
    film.save!
    sibling_film = FactoryGirl.create(:film, master_film_id:
                                      film.master_film_id)
    film.sibling_films.must_include sibling_film
    film.sibling_films.must_include film
  end

  it "does not return non-sibling films" do
    film.save!
    other_film = FactoryGirl.create(:film)
    film.sibling_films.wont_include other_film
  end

  it "calculates the number of sibling films" do
    film.save!
    original_count = film.sibling_count
    2.times { FactoryGirl.create(:film, master_film_id: film.master_film_id) }
    film.sibling_count.must_equal (original_count + 2)
  end

  it "default scope does not include deleted films" do
    film.deleted = true
    film.save!
    Film.all.wont_include(film)
  end

  it "phase scope returns specified phase film" do
    film.phase = "lamination"
    film.save!
    Film.phase("lamination").must_include(film)
  end

  it "phase scope does not return other phase film" do
    film.phase = "something-else"
    film.save!
    Film.phase("lamination").wont_include(film)
  end

  it "by_serial scope orders by serial" do
    film_1 = FactoryGirl.create(:film)
    film_2 = FactoryGirl.create(:film)
    film_3 = FactoryGirl.create(:film, master_film: film_2.master_film)
    Film.by_serial.first.must_equal film_2
    Film.by_serial.last.must_equal film_1
  end

  it "small scope returns < 16sqft film" do
    film.width = 45 
    film.length = 45
    film.save!
    Film.small.must_include(film)
  end

  it "small scope does not return >= 16sqft film" do
    film.width = 48
    film.length = 48
    film.save!
    Film.small.wont_include(film)
  end
  
  it "large scope returns >= 16sqft film" do
    film.width = 50
    film.length = 50
    film.save!
    Film.large.must_include(film)
  end

  it "large scope does not return < 16sqft film" do
    film.width = 40
    film.length = 40
    film.save!
    Film.large.wont_include(film)
  end

  it "reserved scope returns film assigned to line item" do
    film.line_item = FactoryGirl.create(:line_item)
    film.save!
    Film.reserved.must_include(film)
  end

  it "reserved scope does not return unassigned films" do
    film.line_item_id = nil
    film.save!
    Film.reserved.wont_include(film)
  end

  it "not_reserved scope returns unassigned films" do
    film.line_item_id = nil
    film.save!
    Film.not_reserved.must_include(film)
  end

  it "not_reserved scope does not return assigned films" do
    film.line_item = FactoryGirl.create(:line_item)
    film.save!
    Film.not_reserved.wont_include(film)
  end

  it "deleted scope returns deleted film" do
    film.deleted = true
    film.save!
    Film.deleted.must_include(film)
  end

  it "deleted scope does not return active film" do
    film.deleted = false
    film.save!
    Film.deleted.wont_include(film)
  end
end
