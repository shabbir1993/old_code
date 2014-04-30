require 'spec_helper'

describe SalesOrdersController do
  let(:tenant) { instance_double("Tenant", time_zone: "Beijing").as_null_object }
  let(:user) { instance_double("User", admin?: false, tenant: tenant).as_null_object }
  let(:sales_orders) { double.as_null_object }
  let(:sales_order) { instance_double("SalesOrder").as_null_object }
  let(:new_sales_order) { instance_double("SalesOrder").as_null_object }

  before do
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
    set_user_session(user)
    allow(sales_orders).to receive(:find).with("1") { sales_order }
    allow(tenant).to receive(:new_sales_order) { new_sales_order }
    allow(tenant).to receive(:sales_orders) { sales_orders }
  end

  describe "#index" do
    let(:paged_sales_orders) { double }
    let(:filtered_sales_orders) { double }
    before do
      allow(sales_orders).to receive_message_chain(:send, :filter, :by_code) { filtered_sales_orders }
      allow(filtered_sales_orders).to receive(:page).with("2") { paged_sales_orders }
      get :index, page: 2, status: "unshipped"
    end

    it "assigns current tenant sales orders" do
      expect(assigns(:sales_orders)).to eq(paged_sales_orders)
    end
  end

  describe "#new" do
    it "assigns new tenant sales order" do
      get :new
      expect(assigns(:sales_order)).to eq(new_sales_order)
    end
  end

  describe "#create" do
    it "creates a new tenant sales_order when valid" do
      allow(new_sales_order).to receive(:save) { new_sales_order }
      xhr :post, :create, sales_order: {}, format: :js
      expect(response).to render_template(:create)
    end

    it "displays error messages when invalid" do
      allow(new_sales_order).to receive(:save) { false }
      xhr :post, :create, sales_order: {}, format: :js
      expect(response).to render_template(:display_error_messages)
    end
  end

  describe "#edit" do
    it "assigns tenant sales_order" do
      get :edit, id: 1
      expect(assigns(:sales_order)).to eq(sales_order)
    end
  end

  describe "#update" do
    let(:attrs) { double }

    it "updates tenant sales_order when valid" do
      allow(sales_order).to receive(:update_attributes).with(attrs) { sales_order }
      xhr :patch, :update, id: 1, sales_order: attrs, format: :js
      expect(response).to render_template(:update)
    end

    it "displays error messages when invalid" do
      allow(sales_order).to receive(:update_attributes).with(attrs) { false }
      xhr :patch, :update, id: 1, sales_order: attrs, format: :js
      expect(response).to render_template(:display_error_messages)
    end
  end

  describe "#destroy" do
    it "destroys the sales order" do
      expect(sales_order).to receive(:destroy!) { sales_order }
    end
  end
end
