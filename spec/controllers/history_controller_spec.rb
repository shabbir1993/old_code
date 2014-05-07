require 'spec_helper'

describe HistoryController do
  fixtures :users
  fixtures :film_movements
  fixtures :films
  fixtures :master_films

  context "as user" do
    before do
      set_user_session(users(:user))
      @request.env['REMOTE_ADDR'] = '127.0.0.1'
    end

    describe "#index" do
      context "html format" do
        it "assigns film movements" do
          get :index, format: :html
          expect(assigns(:film_movements)).to include(film_movements(:stock_to_wip), film_movements(:lamination_to_inspection))
          expect(response).to render_template(:index)
        end
      end

      context "csv format" do
        it "send data as a csv" do
          get :index, format: :csv
          expect(response.headers["Content-Type"]).to match(/csv/i)
          expect(response.headers["Content-Disposition"]).to match(/attachment/i)
        end
      end
    end
  end
end
