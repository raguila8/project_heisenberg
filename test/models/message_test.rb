require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
		@conversation1 = conversations(:conversation_one)
		@user = users(:rodrigo)
		@message1 = messages(:message_one)
		@message2 = Message.new(body: "blah b;ah blah", read: true, 
												conversation_id: @conversation1.id, user_id: @user.id)
	end

	test "should be valid" do
		assert @message2.valid?
	end

	test "body should be present" do
		@message2.body = "  "
		assert_not @message2.valid?
	end

	test "conversation_id should be present" do
		@message2.conversation_id = ""
		assert_not @message2.valid?
	end

	# Should be able to get converation with @meesage.conversation
	test "user_id should be present" do
		@message2.user_id = " "
		assert_not @message2.valid?
	end

	test "conversation_id should be valid" do
		@message2.conversation_id = 976709
		assert_not @message2.valid?
	end

	test "user_id should be valid" do
		@message2.user_id = 8987986
		assert_not @message2.valid?
	end

	# Should be able to get converation with @meesage.conversation.
	test "should belong to a conversation" do
		assert_not @message2.conversation.nil?
	end

	# Should be able to get the user with @message.user
	test "should belong to a user" do
		assert_not @message2.user.nil?
	end

	
end
