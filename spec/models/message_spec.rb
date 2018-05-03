require "rails_helper"

RSpec.describe Message do
  let(:message) { FactoryBot.build_stubbed(:message, conversation: conversation, user: conversation.sender) }
  let(:conversation) { FactoryBot.create(:conversation) }

  it "should have a conversation" do
    expect(message.valid?).to be_truthy
    message.conversation = nil
    expect(message.valid?).not_to be_truthy
  end

  it "should have a user" do
    expect(message.valid?).to be_truthy
    message.user = nil
    expect(message.valid?).not_to be_truthy
  end

  describe "body" do
    it "should be present" do
      message.body = "This is a sample message"
      expect(message.valid?).to be_truthy
      message.body = nil
      expect(message.valid?).not_to be_truthy
      message.body = ""
      expect(message.valid?).not_to be_truthy
    end

    it "should not be too long" do
      message.body = "a" * 1001
      expect(message.valid?).not_to be_truthy
    end
  end
end
