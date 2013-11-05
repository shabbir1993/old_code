require 'test_helper'

describe MasterFilm do
  let(:master_film) { FactoryGirl.build(:master_film) }

  it "creates nested defects" do
    before_count = Defect.count
    FactoryGirl.create(:master_film, defects_attributes: [FactoryGirl.attributes_for(:defect)])
    Defect.count.must_equal before_count + 1
  end

  it "destroys nested defects" do
    master_film.save!
    defect = FactoryGirl.create(:defect, master_film_id: master_film.id)
    master_film.reload.defects.length.must_equal 1
    master_film.defects_attributes = [FactoryGirl.attributes_for(:defect, id: defect.id, _destroy: '1')]
    master_film.save!
    master_film.reload.defects.length.must_equal 0
  end

  it "creates nested films given required attributes" do
    before_count = Film.count
    FactoryGirl.create(:master_film, films_attributes: [{ width: 1, length: 2, phase: "stock" }])
    Film.count.must_equal before_count + 1
  end

  it "rejects nested films without required attributes" do
    before_count = Defect.count
    FactoryGirl.create(:master_film, films_attributes: [{ phase: "stock" }])
    Film.count.must_equal before_count
  end

  it "requires a serial" do
    master_film.serial = nil
    master_film.invalid?(:serial).must_equal true
  end

  it "rejects invalid serials on create" do
    invalid_serials = ["CD121-2", "4121-4", "J12125", "E0405_2", "a0304-12", "G1212-12a"]
    invalid_serials.each do |serial|
      proc { FactoryGirl.create(:master_film, serial: serial) }.must_raise ActiveRecord::RecordInvalid
    end
  end

  it "does not reject invalid serials on update" do
    invalid_serial = "CD121-2"
    master_film.serial = invalid_serial
    master_film.save!(validate: false)
    master_film.save!.must_equal true
  end
  
  it "accepts valid serials" do
    valid_serials = ["C1212-01", "D4163-13"]
    valid_serials.each do |serial|
      proc { FactoryGirl.create(:master_film, serial: serial) }.must_be_silent
    end
  end

  it "rejects duplicate serials" do
    duplicate_master_film = FactoryGirl.create(:master_film, 
                                               serial: master_film.serial) 
    master_film.invalid?(:serial).must_equal true
  end

  it "active scope includes master films with active children" do
    film = FactoryGirl.create(:film, master_film: master_film, deleted: false)
    MasterFilm.active.must_include master_film
  end

  it "active scope does not include master films without active children" do
    film = FactoryGirl.create(:film, master_film: master_film, deleted: true)
    MasterFilm.active.wont_include master_film
  end

  it "by_serial scope orders by serial" do
  end

  it "has a laminated_at based on the serial" do
    master_film.serial = "E0102-05"
    master_film.laminated_at.must_equal Date.new(2012, 1, 2)
  end

  it "calculates correct effective area given effective dimensions" do
    master_film.effective_width = 60
    master_film.effective_length = 60
    master_film.effective_area.must_equal 25
  end

  it "has a nil effective area given nil effective width" do
    master_film.effective_width = nil
    master_film.effective_length = 1
    master_film.effective_area.must_equal nil
  end

  it "has a nil effective area given nil effective length" do
    master_film.effective_width = 1
    master_film.effective_length = nil
    master_film.effective_area.must_equal nil
  end

  it "calculates correct yield given valid attributes" do
    master_film.effective_width = 60
    master_film.effective_length = 60
    master_film.mix_mass = 100
    master_film.machine = FactoryGirl.create(:machine, yield_constant: 0.5)
    master_film.yield.must_equal 0.5
  end

  it "has nil yield given nil attributes" do
    master_film.effective_width = nil
    master_film.effective_length = nil
    master_film.mix_mass = nil
    master_film.machine = nil
    master_film.yield.must_equal nil
  end

  it "calculates correct defect count" do
    master_film.save!
    2.times { master_film.defects.create!(defect_type: "white spot", count: 2) }
    master_film.defect_count.must_equal 4
  end

  it "machine_code returns machine's code" do
    machine = FactoryGirl.create(:machine)
    master_film.machine_id = machine.id
    master_film.machine_code.must_equal master_film.machine.code
  end
end
