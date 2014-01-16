require 'test_helper'

class ExportHistoryTest < ActionDispatch::IntegrationTest
  before do
    @film = FactoryGirl.create(:film_with_dimensions, phase: "wip")
    with_versioning do
      @film.update_attributes(destination: "fg")
    end
  end

  describe "FG movements history page with user auth" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      log_in(user)
      click_link "History"
      click_link "FG movements"
    end

    it "export link downloads file with movement" do
      skip "with_verioning doesn't work correctly, see paper_trail issue 312"
      click_link "Export"
      page.response_headers["Content-Disposition"].must_equal "attachment"
      page.source.must_include @film.serial
    end
  end
end
