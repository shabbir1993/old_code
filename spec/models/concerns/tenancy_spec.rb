require 'spec_helper'

describe User do
  fixtures :users

  describe "#tenant" do
    it "returns user's tenant" do
      tenant = instance_double("Tenant")
      allow(Tenant).to receive(:new).with('pi') { tenant }
      expect(users(:user).tenant).to eq(tenant)
    end
  end
end
