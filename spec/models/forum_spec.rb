require "rails_helper"

RSpec.describe Forum do
  let (:forum) { FactoryBot.build_stubbed(:forum) }

  describe "name" do
    it "should not be nil" do
      forum.name = nil
      expect(forum.valid?).not_to be_truthy
    end

    it "should not be blank" do
      forum.name = ""
      expect(forum.valid?).not_to be_truthy
    end

    it "should not be too long" do
      forum.name = "a" * 71
      expect(forum.valid?).not_to be_truthy
    end

    it "should not be too short" do
      forum.name = "a" * 2
      expect(forum.valid?).not_to be_truthy
    end

    it "should be unique" do
      FactoryBot.create(:forum, name: "Problems")
      forum.name = "PROBLEMS"
      expect(forum.valid?).not_to be_truthy    # case insensitive
    end
  end
  
  describe "description" do
    it "should not be nil" do
      forum.description = nil
      expect(forum.valid?).not_to be_truthy
    end

    it "should not be blank" do
      forum.description = ""
      expect(forum.valid?).not_to be_truthy
    end

    it "should not be too long" do
      forum.description = "a" * 151
      expect(forum.valid?).not_to be_truthy
    end

    it "should not be too short" do
      forum.description = "a" * 9
      expect(forum.valid?).not_to be_truthy
    end
  end
end
