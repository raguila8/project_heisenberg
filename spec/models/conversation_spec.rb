require "rails_helper"

RSpec.describe Conversation do
  let (:sender) { FactoryBot.create(:user, username: "user1", 
                    email: "user1@example.com") }
  let (:recipient) { FactoryBot.create(:user, username: "user2", 
                    email: "user2@example.com") }
  let (:conversation) { Conversation.new(sender: sender, recipient: recipient) }

  it "should have a sender" do
    expect(conversation.valid?).to be_truthy
    conversation.sender = nil
    expect(conversation.valid?).not_to be_truthy
  end

  it "should have a recipient" do
    conversation.recipient = nil
    expect(conversation.valid?).not_to be_truthy
  end

  it "should have unique sender and recipient pairs" do
    saved_conversation = Conversation.create(sender: sender, recipient: recipient)
    conversation.sender = saved_conversation.sender
    conversation.recipient = saved_conversation.recipient
    expect(conversation.valid?).not_to be_truthy
  end
end
