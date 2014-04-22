require 'spec_helper'

describe HistoryController do
  let(:tenant) { instance_double("Tenant", time_zone: "Beijing").as_null_object }
  let(:user) { instance_double("User", is_admin?: false, tenant: tenant).as_null_object }
  let(:tenant_film_movements) { instance_double("TenantAssets") }
  let(:film_movements) { double }

  before do
    login(user)
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
    expect(TenantAssets).to receive(:new) { tenant_film_movements }
    expect(tenant_film_movements).to receive_message_chain(:all, :exclude_deleted_films, :text_search, :search_date_range, :sort_by_created_at) { film_movements }
  end

  describe "#all_movements" do
    let(:paged_film_movements) { double }
    before do
      expect(film_movements).to receive(:page) { paged_film_movements }
      get :all_movements
    end

    it "assigns film movements" do
      expect(assigns(:film_movements)).to eq(paged_film_movements)
    end

    it "renders the index template" do
      expect(response).to render_template(:all_movements)
    end
  end

  describe "#fg_film_movements" do
    let(:fg_film_movements) { double }
    let(:paged_film_movements) { double }

    before do
      allow(film_movements).to receive(:to_fg) { fg_film_movements }
      allow(fg_film_movements).to receive(:page) { paged_film_movements }
    end

    context "html format" do
      before { get :fg_film_movements, format: :html }

      it "assigns film movements" do
        expect(assigns(:fg_film_movements)).to eq(paged_film_movements)
      end

      it "renders the index template" do
        expect(response).to render_template(:fg_film_movements)
      end
    end

    context "csv format" do
      before do
        get :fg_film_movements, format: :csv
      end

      it "assigns film movements" do
        expect(assigns(:fg_film_movements)).to eq(paged_film_movements)
      end

      it "send data as a csv" do
        expect(response.headers["Content-Type"]).to match(/csv/i)
        expect(response.headers["Content-Disposition"]).to match(/attachment/i)
      end
    end
  end

  describe "#scrap_film_movements" do
    let(:paged_film_movements) { double }
    before do
      expect(film_movements).to receive_message_chain(:to_scrap, :page) { paged_film_movements }
      get :scrap_film_movements
    end

    it "assigns film movements" do
      expect(assigns(:scrap_film_movements)).to eq(paged_film_movements)
    end

    it "renders the index template" do
      expect(response).to render_template(:scrap_film_movements)
    end
  end
end
