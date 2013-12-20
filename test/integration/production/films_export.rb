require 'test_helper'

describe "Films export integration" do

  before do 
    @tenant = FactoryGirl.create(:tenant)
    %w(F0101-01 F0101-02).each do |serial|
      @master_film = FactoryGirl.create(:master_film_with_child, serial: serial, tenant: @tenant)
    end
  end

  describe "clicking the export button with supervisor authentication" do
    let(:supervisor) { FactoryGirl.create(:supervisor, tenant: @tenant) }

    before do
      log_in(supervisor)
      click_link "Production"
      click_link "Export"
    end

    it "downloads a CSV file with films" do
      page.response_headers["Content-Disposition"].must_equal "attachment"
      page.source.must_include "F0101-01-1"
      page.source.must_include "F0101-02-1"
    end
  end
end
