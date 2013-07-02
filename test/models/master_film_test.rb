describe MasterFilm do
  let(:master_film) { FactoryGirl.build(:master_film) }

  it "has a master serial" do
    master_film.master_serial.empty?.must_equal false
  end

  it "creates a child film after create" do
    master_film.save!
    master_film.films.count.must_equal 1
  end

  it "effective area returns decimal given effective width and effective length" do
    master_film.effective_width = 1
    master_film.effective_length = 2
    master_film.effective_area.must_be_instance_of BigDecimal
  end

  it "effective area returns nil without effective width" do
    master_film.effective_width = nil
    master_film.effective_area.must_equal nil
  end

  it "effective area returns nil without effective length" do
    master_film.effective_length = nil
    master_film.effective_area.must_equal nil
  end

  it "defect count returns the correct calculation" do
    master_film.save!
    2.times { master_film.defects.create!(defect_type: "white spot", count: 3) }
    master_film.defect_count.must_equal 6
  end

  it "defect count returns 0 given no defects" do
    master_film.defects.empty?.must_equal true
    master_film.defect_count.must_equal 0
  end

  it "requires a date code" do
    master_film.date_code = nil
    master_film.invalid?(:date_code).must_equal true
  end

  it "requires a number" do
    master_film.number = nil
    master_film.invalid?(:number).must_equal true
  end

  it "requires a formula" do
    master_film.formula = nil
    master_film.invalid?(:formula).must_equal true
  end

  it "rejects duplicate date codes for given number" do
    master_film.save!
    duplicate_master_film = FactoryGirl.build(:master_film, 
                                              date_code: master_film.date_code, 
                                              number: master_film.number) 
    duplicate_master_film.invalid?(:date_code).must_equal true
  end

  it "rejects negative effective widths" do
    master_film.effective_width = -1
    master_film.invalid?(:effective_width).must_equal true
  end
  
  it "rejects negative effective lengths" do
    master_film.effective_length = -1
    master_film.invalid?(:effective_length).must_equal true
  end

  it "machine_code returns machine's code" do
    master_film.machine_code.must_equal master_film.machine.code
  end

  it "chemist_name returns chemist's name" do
    master_film.chemist_name.must_equal master_film.chemist.name
  end

  it "operator_name returns operator's name" do
    master_film.chemist_name.must_equal master_film.chemist.name
  end
end
