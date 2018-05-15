require 'rails_helper'

RSpec.describe "Message controller authorization" do
  let(:conversation) { FactoryBot.create(:conversation) }
  let(:message) { FactoryBot.create(:message, user: conversation.sender, 
                    conversation: conversation) }
  context "signed in" do
    before(:example) do
      sign_in conversation.sender
    end
    it "should create message" do
      message
      my_messages = Message.where(user_id: conversation.sender.id)
      expect(my_messages.count).to eq(1)
      post messages_path, params: { message: { body: "new message", 
                               conversation_id: conversation.id } }, xhr: true
      my_messages = Message.where(user_id: conversation.sender.id)
      expect(my_messages.count).to eq(2)
    end
  end

  context "not signed in" do
    it "should redirect create" do
      message
      my_messages = Message.where(user_id: conversation.sender.id)
      expect(my_messages.count).to eq(1)

      post messages_path, params: { message: { body: "new message", 
                              conversation_id: conversation.id } }, xhr: true
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      my_messages = Message.where(user_id: conversation.sender.id)
      expect(my_messages.count).to eq(1)
    end
  end
end
