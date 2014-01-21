require 'test_helper'

class EditMultipleFilmsTest < ActionDispatch::IntegrationTest
  before do
    use_javascript_driver
    @film1 = FactoryGirl.create(:film_with_dimensions, phase: "stock")
    @film2 = FactoryGirl.create(:film_with_dimensions, phase: "stock")
  end

  describe "edit multiple form" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "Production"
      click_link "Available"
      within('tr', text: @film1.serial) { check 'film_ids_' }
      within('tr', text: @film2.serial) { check 'film_ids_' }
      click_button 'Move selected'
    end

    it "edits films" do
      fill_in 'Shelf', with: "FOO"
      click_button 'Move all'
      assert page.has_selector?("#film-#{@film1.id} .shelf", text: "FOO")
      assert page.has_selector?("#film-#{@film2.id} .shelf", text: "FOO")
    end

    it "moves films" do
      select 'wip', from: 'film_destination'
      click_button 'Move all'
      assert page.has_selector?("#film-#{@film1.id}", text: "wip")
      assert page.has_selector?("#film-#{@film2.id}", text: "wip")
    end
  end
end
