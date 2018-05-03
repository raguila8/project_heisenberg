require "rails_helper"

RSpec.describe Subtopic do
  let (:subtopic) { FactoryBot.build_stubbed(:subtopic) }

  it "should have unique name and branch pairs" do
    expect(subtopic.valid?).to be_truthy
    new_subtopic = FactoryBot.create(:subtopic)
    subtopic.branch = new_subtopic.branch
    subtopic.name = new_subtopic.name
    expect(subtopic.valid?).not_to be_truthy
  end

  describe "name" do
    it "should be nil or blank" do
      subtopic.name = "Momentum"
      expect(subtopic.valid?).to be_truthy
      subtopic.name = nil
      expect(subtopic.valid?).not_to be_truthy
      subtopic.name = ""
      expect(subtopic.valid?).not_to be_truthy
    end
  end

  describe "branch" do
    it "should have a branch" do
      subtopic.branch = nil
      expect(subtopic.valid?).not_to be_truthy
    end
  end
end
