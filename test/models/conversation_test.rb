require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
		@user1 = users(:rodrigo)
		@user2 = users(:archer)
		@conversation1 = conversations(:conversation_one)
		@conversation2 = Conversation.new(sender_id: @user1.id, recipient_id: @user2.id)
	end

	test "should be valid" do
		assert @conversation2.valid?
	end

	test "recipient_id should be present" do
		@conversation2.recipient_id = ""
		assert_not @conversation2.valid?
	end

	test "sender_id should be present" do
		@conversation2.sender_id = ""
		assert_not @conversation2.valid?
	end

	test "recipient_id should be valid" do
		@conversation2.recipient_id = 876875
		assert_not @conversation2.valid?
	end

	test "sender_id should be valid" do
		@conversation2.sender_id = 87576
		assert_not @conversation2.valid?
	end

	# Should be able to see who started the conversation with the 
	# @conversation.sender method
	test "should belong to a sender" do
		assert_not @conversation2.sender.nil?
	end

	# Should be able to get recipient with @conversation.sender
	test "should belong to a recipient" do
		assert_not @conversation2.recipient.nil?
	end

	# Should be able to get all of the conversation's messages with the method
	# @conversation.messages
	test "should have many messages" do
		assert_equal 1, @conversation1.messages.size
	end

	test "messages should be destroyed when conversation is destroyed" do
		assert_equal 2, Conversation.all.size
		@conversation1.destroy
		assert_equal 1, Conversation.all.size
	end

	test "sender_id and recipient_id pair should be unique" do
		duplicate_conversation = @conversation2.dup
		@conversation2.save
		assert_not duplicate_conversation.valid?
	end
end
