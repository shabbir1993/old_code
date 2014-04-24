require 'spec_helper'

shared_examples_for "filterable" do
  let(:model) { described_class } # the class that includes the concern

  describe ".filter" do
    context "with no params" do
      it "doesn't filter" do
        expect(model.filter({})).to eq(model.all)
      end
    end

    context "with param that has no value" do
      it "doesn't filter" do
        expect(model.filter({ foo: "" })).to eq(model.all)
      end
    end

    context "with params" do
      it "filters with all params" do
        filtered_model = double
        expect(model).to receive(:foo).with("value") { filtered_model }
        expect(filtered_model).to receive(:bar).with("other value")
        model.filter({ foo: "value", bar: "other value" })
      end
    end
  end
end
