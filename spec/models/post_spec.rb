require "rails_helper"

RSpec.describe Post do
  let(:post) { FactoryBot.build_stubbed(:post) }

  describe "content" do
    it "should be present" do
      post.content = "This is a post"
      expect(post.valid?).to be_truthy
      post.content = nil
      expect(post.valid?).not_to be_truthy
      post.content = ""
      expect(post.valid?).not_to be_truthy
    end

    it "should not be too short" do
      post.content = "aa"
      expect(post.valid?).not_to be_truthy
    end

    it "should not be too long" do
      post.content = "a" * 50001
      expect(post.valid?).not_to be_truthy
    end
  end

  describe "user" do
    it "should be present" do
      post.user = nil
      expect(post.valid?).not_to be_truthy
    end
  end

  describe "topic" do
    it "should be present" do
      post.topic = nil
      expect(post.valid?).not_to be_truthy
    end
  end
end
