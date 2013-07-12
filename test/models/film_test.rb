describe Film do
  let(:film) { FactoryGirl.build(:film) }

  it "has a serial" do
    film.serial.empty?.must_equal false
  end

  it "sets correct division on create" do
    FactoryGirl.create(:film, master_film_id: film.master_film_id)
    film.save!
    film.division.must_equal 2
  end

  it "destination setter sets phase if not empty" do
    film.phase = "lamination"
    film.destination = "inspection"
    film.save!
    film.phase.must_equal "inspection"
  end

  it "destination setter does not set phase if empty" do
    film.phase = "lamination"
    film.destination = ""
    film.save!
    film.phase.must_equal "lamination"
  end

  it "sets width and length to master film's effective width and effective length after save if nil" do
    film.width = nil
    film.length = nil
    film.master_film.effective_width = 50
    film.master_film.effective_length = 50
    film.save!
    film.width.must_equal 50
    film.length.must_equal 50
  end

  it "does not set width and length to master film's effective width and effective length on save if not nil" do
    film.width = 40
    film.length = 40
    film.master_film.effective_width = 50
    film.master_film.effective_length = 50
    film.save!
    film.width.must_equal 40
    film.length.must_equal 40
  end

  it "valid_destinations must return an array" do
    film.valid_destinations.must_be_instance_of Array
  end

  it "effective_width returns master film effective width" do
    film.effective_width.must_equal film.master_film.effective_width
  end
  
  it "effective_length returns master film effective length" do
    film.effective_length.must_equal film.master_film.effective_length
  end

  it "effective_area returns master film effective area" do
    film.effective_area.must_equal film.master_film.effective_area
  end

  it "area returns nil with no width or length" do
    film.width = nil
    film.area.must_equal nil
  end

  it "area returns decimal given width and length" do
    film.width = 1
    film.length = 2
    film.area.must_be_instance_of BigDecimal
  end

  it "custom area returns nil with no custom width or custom area" do
    film.custom_length = nil
    film.custom_area.must_equal nil
  end

  it "custom area returns decimal with custom width and custom length" do
    film.custom_width = 1
    film.custom_length = 2
    film.custom_area.must_be_instance_of BigDecimal
  end

  it "utilization returns nil with no width, length, custom width or custom length" do
    film.width = nil
    film.utilization.must_equal nil
  end

  it "utilization returns decimal given width, length, custom width or custom length" do
    film.width = 1
    film.length = 2
    film.custom_width = 1
    film.custom_length = 2
    film.utilization.must_be_instance_of BigDecimal
  end

  it "defect_count returns master film defect count" do
    film.defect_count.must_equal film.master_film.defect_count
  end

  it "mix_mass returns master film mix mass" do
    film.mix_mass.must_equal film.master_film.mix_mass
  end

  it "machine_code returns master film machine_code" do
    film.machine_code.must_equal film.master_film.machine_code
  end

  it "film_code returns master film film code" do
    film.film_code.must_equal film.master_film.film_code
  end

  it "thinky_code returns master film thinky code" do
    film.thinky_code.must_equal film.master_film.thinky_code
  end

  it "chemist_name returns master film chemist_name" do
    film.chemist_name.must_equal film.master_film.chemist_name
  end

  it "operator_name returns master film operator_name" do
    film.operator_name.must_equal film.master_film.operator_name
  end

  it "requires a phase" do
    film.phase = nil
    film.invalid?(:phase).must_equal true
  end

  it "requires a master film id" do
    film.master_film_id = nil
    film.invalid?(:master_film_id).must_equal true
  end

  it "rejects negative widths" do
    film.width = -1
    film.invalid?(:width).must_equal true
  end

  it "rejects negative lengths" do
    film.length = -1
    film.invalid?(:length).must_equal true
  end

  it "split builds and returns new sibling films" do
    film.save!
    film.split(2).each do |s|
      s.master_film_id.must_equal film.master_film_id
    end
  end

  it "phase scope should return specified phase film" do
    film.phase = "lamination"
    film.save!
    Film.phase("lamination").must_include(film)
  end

  it "phase scope should not return other phase film" do
    film.phase = "something-else"
    film.save!
    Film.phase("lamination").wont_include(film)
  end

  it "small scope should return < 16sqft film" do
    film.width = 45 
    film.length = 45
    film.save!
    Film.small.must_include(film)
  end

  it "small scope should not return >= 16sqft film" do
    film.width = 48
    film.length = 48
    film.save!
    Film.small.wont_include(film)
  end
  
  it "large scope should return >= 16sqft film" do
    film.width = 50
    film.length = 50
    film.save!
    Film.large.must_include(film)
  end

  it "large scope should not return < 16sqft film" do
    film.width = 40
    film.length = 40
    film.save!
    Film.large.wont_include(film)
  end
end
