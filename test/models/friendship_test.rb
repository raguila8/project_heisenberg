require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase

	def setup
  	@user1 = users(:rodrigo)
		@user2 = users(:michael)
		@friendship1 = friendships(:friendship_one)
		@friendship2 = friendships(:friendship_two)
		@friendship3 = Friendship.new(user_id: @user1.id, friend_id: @user2.id)
	end

	test "should be valid" do
		assert @friendship3.valid?
	end

	test "user_id should be present" do
		@friendship3.user_id = ""
		assert_not @friendship3.valid?
	end

	test "friend_id should be present" do
		@friendship3.friend_id = ""
		assert_not @friendship3.valid?
	end

	# Should be able to get the corresponding user in the friendship with 
	# Friendship.user
	test "should belong to user" do
		assert_not @friendship3.user.nil?
	end

	# Should be able to get the corresponding friend in the friendship with
	# Friendship.friend
	test "should belong to friend" do
		assert_not @friendship3.friend.nil?
	end

end
