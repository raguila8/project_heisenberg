require 'rails_helper'

RSpec.describe "Conversation controller authorization" do
  let(:conversation) {FactoryBot.create(:conversation) }
  let(:other_conversation) { FactoryBot.create(:conversation, 
           sender: other_user, recipient: conversation.recipient) }
  let(:other_user) { FactoryBot.create(:other_user) }
  context "signed in" do
    before(:example) do
      sign_in conversation.sender
    end

    it "should create a new conversation" do
      my_conversations = Conversation.where("sender_id=:user_id OR " + 
                                             "recipient_id=:user_id", 
                                              user_id: conversation.sender.id)
      expect(my_conversations.count).to eq(1)
      post conversations_path params: { username: other_user.username, 
                                        body: "message content" }, format: :js
      expect(Conversation.where('sender_id=:user_id OR recipient_id=:user_id',
                              user_id: conversation.sender.id).count).to eq(2)
    end

    it "should show conversation" do
      FactoryBot.create(:message, user: conversation.sender, 
                                          conversation: conversation)
      get conversation_path(id: conversation.id)
      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to be_nil
    end

    it "should redirect show if conversation does not belong to user" do
      FactoryBot.create(:message, user: other_conversation.sender, 
                                          conversation: conversation)
      get conversation_path(id: other_conversation.id)
    end
  end

  context "not signed in" do
    it "should redirect create" do
      conversations_count = Conversation.all.count
      post conversations_path params: { username: other_user.username, 
                                        body: "message content" }, format: :js

      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")
      expect(Conversation.all.count).to eq(conversations_count)
    end

    it "should redirect show" do
      get conversation_path(id: conversation.id)
      expect(response).to redirect_to(controller: "sessions", action: "new")
      expect(flash[:alert]).to match("You need to sign in or " + 
                                               "sign up before continuing.")

    end
  end
end
