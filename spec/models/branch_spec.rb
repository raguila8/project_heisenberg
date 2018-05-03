require "rails_helper"

RSpec.describe Branch do
  let (:branch) { FactoryBot.build_stubbed(:branch) }

  describe "name" do
    it "should be nil or blank" do
      branch.name = "Classical Mechanics"
      expect(branch.valid?).to be_truthy
      branch.name = nil
      expect(branch.valid?).not_to be_truthy
      branch.name = ""
      expect(branch.valid?).not_to be_truthy
    end

    it "should be unique" do
      new_branch = Branch.create(name: "Classical Mechanics")
      branch.name = new_branch.name.upcase    # case insensitive
      expect(branch.valid?).not_to be_truthy
    end
  end
end
