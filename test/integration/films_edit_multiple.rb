require 'test_helper'

describe "Films edit multiple integration" do
  before do
    Capybara.current_driver = Capybara.javascript_driver
    @tenant = FactoryGirl.create(:tenant)
    @film1 = FactoryGirl.create(:film_with_dimensions, phase: "stock", tenant: @tenant)
    @film2 = FactoryGirl.create(:film_with_dimensions, phase: "stock", tenant: @tenant)
  end

  describe "edit multiple form with supervisor auth" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Production"
      click_link "Available"
      within('tr', text: @film1.serial) { check 'film_ids_' }
      within('tr', text: @film2.serial) { check 'film_ids_' }
      click_button 'Move selected'
    end

    it "edits films" do
      fill_in 'Shelf', with: "Foo"
      click_button 'Move all'
      page.has_selector?("#film-#{@film1.id} td.shelf", text: "Foo")
      page.has_selector?("#film-#{@film2.id} td.shelf", text: "Foo")
    end

    it "moves films" do
      select 'wip', from: 'film_destination'
      click_button 'Move all'
      page.has_selector?("#film-#{@film1.id}", text: "inspection")
      page.has_selector?("#film-#{@film2.id}", text: "inspection")
    end
  end
end
