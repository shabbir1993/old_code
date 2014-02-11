require 'test_helper'

class ExportFilmsTest < ActionDispatch::IntegrationTest

  before do 
    FactoryGirl.create(:master_film_with_child, serial: "F0101-01")
  end

  describe "production page" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      log_in(admin)
      click_link "Production"
      click_link "Lamination"
    end

    it "export link downloads file with films" do
      click_link "Export"
      page.response_headers["Content-Disposition"].must_equal "attachment"
      page.source.must_include "F0101-01-1"
    end
  end
end
