require 'spec_helper'

describe HistoryController do
  let(:tenant) { instance_double("Tenant", time_zone: "Beijing").as_null_object }

  context "user session" do
    let(:user) { instance_double("User", admin?: false, tenant: tenant).as_null_object }
    before do
      @request.env['REMOTE_ADDR'] = '127.0.0.1'
      set_user_session(user)
    end

    describe "#index" do
      let(:film_movements) { double }
      let(:paged_film_movements) { double }
      let(:dimensions_map_data) { instance_double("DimensionsMapData") }

      before do
        allow(tenant).to receive_message_chain(:film_movements, :exclude_deleted_films, :filter, :sort_by_created_at) { film_movements }
        allow(film_movements).to receive(:page) { paged_film_movements }
        allow(DimensionsMapData).to receive(:new).with(film_movements) { dimensions_map_data }
      end

      context "html format" do
        before { get :index, format: :html }

        it "assigns film movements" do
          expect(assigns(:film_movements)).to eq(paged_film_movements)
          expect(assigns(:dimensions_map_data)).to eq(dimensions_map_data)
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
end
