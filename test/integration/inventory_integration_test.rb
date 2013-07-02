describe "Inventory integration" do

  before { visit films_path }
  let(:film1) { FactoryGirl.create(:master_film).films.first }
  let(:film2) { FactoryGirl.create(:master_film).films.first }
  let(:film3) { FactoryGirl.create(:master_film).films.first }

  it "has the right title" do
    assert page.has_title?("Inventory").must_equal true
  end

  it "creates a new film given valid attributes" do
    FactoryGirl.create(:machine)
    FactoryGirl.create(:chemist)
    FactoryGirl.create(:operator)
    attrs = FactoryGirl.attributes_for(:master_film)
    click_link 'New Film'
    fill_in 'Date code', with: attrs[:date_code]
    fill_in 'Number', with: attrs[:number]
    fill_in 'Formula', with: attrs[:formula]
    fill_in 'Mix mass', with: attrs[:mix_mass]
    select find_field('master_film_machine_id').find('option').text, from: 'Machine'
    fill_in 'Film code', with: attrs[:film_code]
    fill_in 'Thinky code', with: attrs[:thinky_code]
    select find_field('master_film_chemist_id').find('option').text, from: 'Chemist'
    select find_field('master_film_operator_id').find('option').text, from: 'Operator'
    click_button 'Create'
    assert page.has_selector?('div.alert.alert-success').must_equal true
    assert page.has_selector?('td', text: attrs[:date_code]).must_equal true
  end

  it "displays error messages given invalid attributes" do
    click_link 'New Film'
    click_button 'Create'
    assert page.has_selector?('div.error-messages').must_equal true
  end

  describe "lamination tab with one film" do
    before do
      film1.update_attributes!(phase: "lamination")
      click_link 'Lamination'
    end 

    describe "edit form" do
      before do
        FactoryGirl.create(:machine, code: "NM")
        FactoryGirl.create(:chemist, name: "New Chemist")
        FactoryGirl.create(:operator, name: "New Operator")
        within('tr', text: film1.serial) do
          click_link 'Edit'
        end
      end

      it "updates film given valid attributes and no destination" do
        fill_in 'Mix mass', with: 123.4
        select 'NM', from: 'Machine'
        fill_in 'Film code', with: "NewCode"
        fill_in 'Thinky code', with: "123"
        fill_in 'Reserved', with: "new reserved"
        fill_in 'Note', with: "new note"
        select 'New Chemist', from: 'Chemist'
        select 'New Operator', from: 'Operator'
        click_button 'Update'
        click_link 'Lamination'
        assert page.has_selector?('tbody td', text: "123.4")
        assert page.has_selector?('tbody td', text: "NM" )
        assert page.has_selector?('tbody td', text: "NewCode")
        assert page.has_selector?('tbody td', text: "123")
        assert page.has_selector?('tbody td', text: "new reserved")
        assert page.has_selector?('tbody td', text: "new note")
        assert page.has_selector?('tbody td', text: "New Chemist")
        assert page.has_selector?('tbody td', text: "New Operator")
      end

      it "moves film to inspection given valid attributes" do
        select 'inspection', from: 'film_phase'
        click_button 'Update'
        click_link 'Inspection'
        assert page.has_selector?('tbody td', text: film1.serial)
      end
    end
  end

  describe "inspection tab with one film" do
    before do
      Capybara.current_driver = Capybara.javascript_driver
      film1.update_attributes!(phase: "inspection")
      visit films_path
      click_link 'Inspection'
    end 

    describe "edit form" do
      before do
        within('tr', text: film1.serial) do
          click_link 'Edit'
        end
      end
      
      it "unhides backend fields and moves film to stock given valid attributes" do
        select 'stock', from: 'film_phase'
        page.has_selector?('.backend-fields', visible: true).must_equal true
        fill_in 'Shelf', with: "M1"
        click_button 'Update'
        click_link 'Stock'
        assert page.has_selector?('tbody td', text: film1.serial)
        assert page.has_selector?('tbody td', text: "M1")
      end

      it "adds defects given valid attributes" do
        click_link "Add defect"
        select 'white spot', from: 'Defect type'
        fill_in 'Count', with: 3
        click_button 'Update'
        within('tr', text: film1.serial) do
          assert page.has_selector?('td.defect_count', text: '3')
        end
      end

      it "doesn't add defects given invalid attributes" do
        click_link "Add defect"
        click_button 'Update'
        within('tr', text: film1.serial) do
          assert page.has_selector?('td.defect_count', text: '0')
        end
      end
    end

    describe "edit form with defects" do
      before do
        FactoryGirl.create(:defect, count: 1, master_film: film1.master_film)
        FactoryGirl.create(:defect, count: 1, master_film: film1.master_film)
        within('tr', text: film1.serial) do
          click_link 'Edit'
        end
      end

      it "remove button removes defect" do
        first("a.remove-fields").click
        click_button 'Update'
        within('tr', text: film1.serial) do
          assert page.has_selector?('td.defect_count', text: '1')
        end
      end
    end
  end

  describe "stock tab with multiple films" do
    before do
      film1.update_attributes!(phase: "stock")
      film2.update_attributes!(phase: "stock")
      film3.update_attributes!(phase: "stock")
      click_link 'Stock'
    end

    it "displays the correct number of films" do
      assert page.has_selector?('tbody tr', count: 3)
    end

    describe "split form" do
      before do
        within('tr', text: film1.serial) do
          click_link "Split"
        end
      end
    
      it "splits film" do
        within('fieldset.division-1-fields') do
          fill_in 'Width', with: 11
          fill_in 'Length', with: 22
        end
        within('fieldset.division-2-fields') do
          fill_in 'Width', with: 33
          fill_in 'Length', with: 44
        end
        click_button "Split"
        assert page.has_selector?('tr', text: film1.master_serial, count: 2)
        assert page.has_selector?('td.width', text: 11)
        assert page.has_selector?('td.length', text: 22)
        assert page.has_selector?('td.width', text: 33)
        assert page.has_selector?('td.length', text: 44)
      end
    end

    describe "with 2 films checked" do
      before do
        within('tr', text: film1.serial) { check 'film_ids_' }
        within('tr', text: film2.serial) { check 'film_ids_' }
      end

      it "moves them to wip given destination" do
        click_button 'Move selected'
        select 'wip', from: 'film_phase'
        click_button 'Move all'
        click_link 'WIP'
        assert page.has_selector?('tbody tr', text: film1.serial)
        assert page.has_selector?('tbody tr', text: film2.serial)
      end

      it "does not move them to wip given no destination" do
        click_button 'Move selected'
        click_button 'Move all'
        visit films_path
        click_link 'Stock'
        assert page.has_selector?('tbody tr', text: film1.serial)
        assert page.has_selector?('tbody tr', text: film2.serial)
      end
    end
  end
end
