require 'test_helper'

class ExportHistoryTest < ActionDispatch::IntegrationTest
  before do
    @film = FactoryGirl.create(:film_with_dimensions, phase: "wip")
    @film.update_attributes(destination: "fg")
  end

  describe "FG movements history page" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "History"
      click_link "FG movements"
    end

    it "export link downloads file with movement" do
      click_link "Export"
      page.response_headers["Content-Disposition"].must_equal "attachment"
      page.source.must_include @film.serial
    end
  end
end
