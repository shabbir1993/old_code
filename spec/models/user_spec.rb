require 'spec_helper'

describe User do
  describe ".chemists" do
    context "with some chemists" do
      before do
        ["Chemist One", "Chemist Two"].each do |name|
          create(:chemist, full_name: name)
        end
      end
      it "returns the chemists' names" do
        expect(User.chemists).to match_array(["Chemist One", "Chemist Two"])
      end
    end

    context "with no chemists" do
      it "returns an empty array" do
        expect(User.chemists).to match_array([])
      end
    end
  end

  describe ".operators" do
    context "with some operators" do
      before do
        ["operator One", "operator Two"].each do |name|
          create(:operator, full_name: name)
        end
      end
      it "returns the operators' names" do
        expect(User.operators).to match_array(["operator One", "operator Two"])
      end
    end

    context "with no operators" do
      it "returns an empty array" do
        expect(User.operators).to match_array([])
      end
    end
  end

  describe ".inspectors" do
    context "with some inspectors" do
      before do
        ["inspector One", "inspector Two"].each do |name|
          create(:inspector, full_name: name)
        end
      end
      it "returns the inspectors' names" do
        expect(User.inspectors).to match_array(["inspector One", "inspector Two"])
      end
    end

    context "with no inspectors" do
      it "returns an empty array" do
        expect(User.inspectors).to match_array([])
      end
    end
  end

  describe "#is_admin?" do
    it "returns true when user is an admin" do
      admin = build_stubbed(:admin)
      expect(admin.is_admin?).to eq(true)
    end
    it "returns false when user is not an admin" do
      not_admin = build_stubbed(:user)
      expect(not_admin.is_admin?).to eq(false)
    end
  end

  describe "#role_title" do
    it "returns user when role_level is 0" do
      user = build_stubbed(:user, role_level: 0)
      expect(user.role_title).to eq("User")
    end

    it "returns admin when role_level is 1" do
      user = build_stubbed(:user, role_level: 1)
      expect(user.role_title).to eq("Admin")
    end

    it "raises an error when role_level is something else" do
      user = build_stubbed(:user, role_level: 2)
      expect{ user.role_title }.to raise_error(User::InvalidRoleError)
    end
  end

  describe "#tenant" do
    it "returns the tenant User belongs to" do
      tenant = instance_double("Tenant")
      allow(Tenant).to receive(:new).with('pi') { tenant }
      user = build_stubbed(:user, tenant_code: 'pi')
      expect(user.tenant).to eq(tenant)
    end
  end
end
