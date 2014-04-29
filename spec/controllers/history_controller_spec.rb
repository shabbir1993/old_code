require 'spec_helper'

describe HistoryController do
  let(:tenant) { instance_double("Tenant", time_zone: "Beijing").as_null_object }
  let(:user) { instance_double("User", admin?: false, tenant: tenant).as_null_object }
  let(:tenant_film_movements) { instance_double("TenantAssets") }
  let(:film_movements) { double }

  before do
    set_user_session(user)
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
    expect(TenantAssets).to receive(:new) { tenant_film_movements }
    expect(tenant_film_movements).to receive_message_chain(:all, :exclude_deleted_films, :filter, :sort_by_created_at) { film_movements }
  end

  describe "#index" do
    let(:paged_film_movements) { double }
    let(:movement_map_data) { instance_double("MovementmapData") }
    let(:dimensions_map_data) { instance_double("DimensionsMapData") }

    before do
      allow(film_movements).to receive(:page) { paged_film_movements }
      allow(MovementMapData).to receive(:for).with(film_movements) { movement_map_data }
      allow(DimensionsMapData).to receive(:new).with(film_movements) { dimensions_map_data }
    end

    context "html format" do
      before { get :index, format: :html }

      it "assigns film movements" do
        expect(assigns(:film_movements)).to eq(paged_film_movements)
      end

      it "assigns movement map data" do
        expect(assigns(:movement_map_data)).to eq(movement_map_data)
      end

      it "assigns dimensions map data" do
        expect(assigns(:dimensions_map_data)).to eq(dimensions_map_data)
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end
    end

    context "csv format" do
      before { get :index, format: :csv }

      it "send data as a csv" do
        expect(response.headers["Content-Type"]).to match(/csv/i)
        expect(response.headers["Content-Disposition"]).to match(/attachment/i)
      end
    end
  end
end
