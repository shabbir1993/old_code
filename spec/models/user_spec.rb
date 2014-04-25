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

  describe "#tenant" do
    it "returns the tenant User belongs to" do
      tenant = instance_double("Tenant")
      allow(Tenant).to receive(:new).with('pi') { tenant }
      user = build_stubbed(:user, tenant_code: 'pi')
      expect(user.tenant).to eq(tenant)
    end
  end
end
