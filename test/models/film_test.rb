describe Film do
  let(:master_film) { FactoryGirl.create(:master_film) }
  let(:film) { master_film.films.first }

  it "has a serial" do
    film.serial.empty?.must_equal false
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

  it "area returns decimal with width and length" do
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
    film.defect_count.must_equal master_film.defect_count
  end

  it "mix_mass returns master film mix mass" do
    film.mix_mass.must_equal master_film.mix_mass
  end

  it "machine_code returns master film machine_code" do
    film.machine_code.must_equal master_film.machine_code
  end

  it "film_code returns master film film code" do
    film.film_code.must_equal master_film.film_code
  end

  it "thinky_code returns master film thinky code" do
    film.thinky_code.must_equal master_film.thinky_code
  end

  it "chemist_name returns master film chemist_name" do
    film.chemist_name.must_equal master_film.chemist_name
  end

  it "operator_name returns master film operator_name" do
    film.operator_name.must_equal master_film.operator_name
  end

  it "requires a division" do
    film.division = nil
    film.invalid?(:division).must_equal true   
  end

  it "requires a master film id" do
    film.master_film_id = nil
    film.invalid?(:master_film_id).must_equal true
  end

  it "requires a phase" do
    film.phase = nil
    film.invalid?(:phase).must_equal true
  end

  it "rejects duplicate divisions for given parent master film" do
    duplicate_film = master_film.films.build
    duplicate_film.division = film.division
    duplicate_film.invalid?(:division).must_equal true
  end

  it "rejects negative widths" do
    film.width = -1
    film.invalid?(:width).must_equal true
  end

  it "rejects negative lengths" do
    film.length = -1
    film.invalid?(:length).must_equal true
  end

  it "sets phase to lamination for films with division 1" do
    film.phase.must_equal "lamination"
  end

  it "sets phase to stock for films with division > 1" do
    subsequent_film = master_film.films.create(division: 2)
    subsequent_film.phase.must_equal "stock"
  end
  
  it "sets default division to highest sibling + 1" do
    film.division = 4
    film.save!
    next_film = film.master_film.films.build
    next_film.division.must_equal 5
  end

  it "sets first film's division to 1" do
    film.division.must_equal 1
  end

  it "lamination scope should return lamination film" do
    film.update_attributes(phase: "lamination")
    Film.lamination.must_include(film)
  end

  it "lamination scope should not return non-lamination film" do
    film.update_attributes(phase: "something-else")
    Film.lamination.wont_include(film)
  end

  it "inspection scope should return inspection film" do
    film.update_attributes(phase: "inspection")
    Film.inspection.must_include(film)
  end

  it "inspection scope should not return non-inspection film" do
    film.update_attributes(phase: "something-else")
    Film.inspection.wont_include(film)
  end


  it "stock scope should return stock film" do
    film.update_attributes(phase: "stock")
    Film.stock.must_include(film)
  end

  it "stock scope should not return non-stock film" do
    film.update_attributes(phase: "something-else")
    Film.stock.wont_include(film)
  end

  it "wip scope should return wip film" do
    film.update_attributes(phase: "wip")
    Film.wip.must_include(film)
  end

  it "wip scope should not return non-wip film" do
    film.update_attributes(phase: "something-else")
    Film.wip.wont_include(film)
  end


  it "fg scope should return fg film" do
    film.update_attributes(phase: "fg")
    Film.fg.must_include(film)
  end

  it "fg scope should not return non-fg film" do
    film.update_attributes(phase: "something-else")
    Film.fg.wont_include(film)
  end


  it "testing scope should return testing film" do
    film.update_attributes(phase: "testing")
    Film.testing.must_include(film)
  end

  it "testing scope should not return non-testing film" do
    film.update_attributes(phase: "something-else")
    Film.testing.wont_include(film)
  end


  it "nc scope should return nc film" do
    film.update_attributes(phase: "nc")
    Film.nc.must_include(film)
  end

  it "nc scope should not return non-nc film" do
    film.update_attributes(phase: "something-else")
    Film.nc.wont_include(film)
  end


  it "scrap scope should return scrap film" do
    film.update_attributes(phase: "scrap")
    Film.scrap.must_include(film)
  end

  it "scrap scope should not return non-scrap film" do
    film.update_attributes(phase: "something-else")
    Film.scrap.wont_include(film)
  end
end
