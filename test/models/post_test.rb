require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
		@user = users(:rodrigo)
		@topic1 = topics(:topic_one)
		@post = Post.new(content: "ipsum blah blah", topic_id: @topic1.id, 
											user_id: @user.id, kudos: 10)
		@other_post = posts(:post_one)
	end

	test "should be valid" do
		assert @post.valid?
	end

	test "content should be present" do
		@post.content = " "
		assert_not @post.valid?
	end

	test "user_id should be present" do
		@post.user_id = ""
		assert_not @post.valid?
	end

	test "topic_id should be present" do
		@post.topic_id = ""
		assert_not @post.valid?
	end

	# Every post should belong to a topic
	test "should belong to a topic" do
		assert_not @other_post.topic.nil?
	end

	# Every post should belong to a user
	test "should belong to a user" do
		assert_not @other_post.user.nil?
	end
end
