require "rails_helper"

RSpec.describe Comment do
  let(:comment) { FactoryBot.build_stubbed(:comment) }

  describe "content" do
    it "should be present" do
      comment.content = "This is a comment"
      expect(comment.valid?).to be_truthy
      comment.content = nil
      expect(comment.valid?).not_to be_truthy
      comment.content = ""
      expect(comment.valid?).not_to be_truthy
    end

    it "should not be too short" do
      comment.content = "aa"
      expect(comment.valid?).not_to be_truthy
    end

    it "should not be too long" do
      comment.content = "a" * 3001
      expect(comment.valid?).not_to be_truthy
    end
  end

  describe "user" do
    it "should be present" do
      comment.user = nil
      expect(comment.valid?).not_to be_truthy
    end
  end

  describe "post" do
    it "should be present" do
      comment.post = nil
      expect(comment.valid?).not_to be_truthy
    end
  end
end
