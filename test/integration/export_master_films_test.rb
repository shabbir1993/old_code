require 'test_helper'

class ExportMasterFilmsTest < ActionDispatch::IntegrationTest

  before { @master_film = FactoryGirl.create(:master_film_with_child) }

  describe "engineering page with admin auth" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Engineering"
    end

    it "export button downloads a file with master films" do
      click_link "Export"
      page.response_headers["Content-Disposition"].must_equal "attachment"
      page.source.must_include @master_film.serial
    end
  end
end
