require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
		@forum = forums(:forum_one)
		@problem = problems(:problem_three)
		@problem2 = problems(:problem_four)
		@topic1 = topics(:topic_one)
		@topic2 = Topic.new(name: "Problem 3", forum_id: @forum.id,
												problem_id: @problem.id)
	end

	test "should be valid" do
		assert @topic2.valid?
	end

	test "name should be present" do
		@topic2.name = "   "
		assert_not @topic2.valid?
	end

	test "forum should be present" do
		@topic2.forum_id = ""
		assert_not @topic2.valid?
	end

	test "problem should be unique" do
		duplicate_topic = @topic2.dup
		# Making sure to change name to make sure that we are specifically
		# testing the uniqueness of problem_id.
		duplicate_topic.name = "random name"
		@topic2.save
		assert_not duplicate_topic.valid?
	end

	test "name should be unique" do
		duplicate_topic = @topic2.dup
		# Making sure to change problem_id to make sure that we are specifically
		# testing the uniqueness of name.
		duplicate_topic.problem_id = @problem2.id
		@topic2.save
		assert_not duplicate_topic.valid?
	end

	# Tests the belongs_to association with the problem model
	test "should belong to problem" do
		assert_equal @problem.id, @topic2.problem.id
	end

	# Tests the has_many association with the post data model
	test "should have many posts" do
		assert 2, @topic1.posts.size
	end

	# Tests the belongs_to association with the forum data model
	test "should belong to forum" do
		assert_equal @forum.id, @topic2.forum.id
	end

	# When a topic is destroyed, its posts must be destroyed as well
	test "posts are destoryed when topic is destroyed" do
		assert_equal 4, Post.all.size
		@topic1.destroy
		assert_equal 2, Post.all.size
	end

end
