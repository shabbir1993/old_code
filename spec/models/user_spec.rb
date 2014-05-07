require 'spec_helper'

describe User do
  fixtures :users

  describe ".names" do
    it "returns all user full names" do
      expect(User.names).to match(["Jame Moore", "Kevin Su"])
    end
  end
end
