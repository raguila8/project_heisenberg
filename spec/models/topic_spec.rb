require "rails_helper"

RSpec.describe Topic do
  let (:topic) { FactoryBot.build_stubbed(:topic) }

  it "should have unique name and forum pairs" do
    saved_topic = FactoryBot.create(:topic)
    topic.name = saved_topic.name
    topic.forum = saved_topic.forum
    expect(topic.valid?).not_to be_truthy
  end

  describe "name" do
    it "should not be nil or blank" do
      topic.name = "Problem 1"
      expect(topic.valid?).to be_truthy
      topic.name = nil
      expect(topic.valid?).not_to be_truthy
      topic.name = ""
      expect(topic.valid?).not_to be_truthy
    end

    it "should not be too long" do
      topic.name = "a" * 151
      expect(topic.valid?).not_to be_truthy
    end
  end

  describe "forum" do
    it "should not be nil" do
      topic.forum = nil
      expect(topic.valid?).not_to be_truthy
    end
  end

  describe "problem" do
    it "should be unique" do
      saved_topic = FactoryBot.create(:topic)
      expect(topic.valid?).to be_truthy
      topic.problem = saved_topic.problem
      expect(topic.valid?).not_to be_truthy
    end
  end
end
