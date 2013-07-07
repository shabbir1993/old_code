describe MasterFilm do
  let(:master_film) { FactoryGirl.build(:master_film) }

  it "effective area returns decimal given effective width and effective length" do
    master_film.effective_width = 1
    master_film.effective_length = 2
    master_film.effective_area.must_be_instance_of BigDecimal
  end

  it "effective area returns nil without effective width" do
    master_film.effective_width = nil
    master_film.effective_length = 1
    master_film.effective_area.must_equal nil
  end

  it "effective area returns nil without effective length" do
    master_film.effective_width = 1
    master_film.effective_length = nil
    master_film.effective_area.must_equal nil
  end

  it "defect count returns the correct calculation" do
    master_film.save!
    2.times { master_film.defects.create!(defect_type: "white spot", count: 3) }
    master_film.defect_count.must_equal 6
  end

  it "requires a serial" do
    master_film.serial = nil
    master_film.invalid?(:serial).must_equal true
  end

  it "rejects duplicate serials" do
    duplicate_master_film = FactoryGirl.create(:master_film, 
                                              serial: master_film.serial) 
    master_film.invalid?(:serial).must_equal true
  end

  it "machine_code returns machine's code" do
    machine = FactoryGirl.create(:machine)
    master_film.machine_id = machine.id
    master_film.machine_code.must_equal master_film.machine.code
  end

  it "chemist_name returns chemist's name" do
    chemist = FactoryGirl.create(:chemist)
    master_film.chemist_id = chemist.id
    master_film.chemist_name.must_equal master_film.chemist.name
  end

  it "operator_name returns operator's name" do
    operator = FactoryGirl.create(:operator)
    master_film.operator_id = operator.id
    master_film.operator_name.must_equal master_film.operator.name
  end
end
