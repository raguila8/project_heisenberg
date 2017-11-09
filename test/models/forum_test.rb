require 'test_helper'

class ForumTest < ActiveSupport::TestCase
	def setup
		@forum1 = forums(:forum_one)
		@forum2 = Forum.new(name: "random forum", 
												description: "forum of randomness")
	end

	test "should be valid" do
		assert @forum2.valid?
	end

	test "name should be present" do
		@forum2.name = "   "
		assert_not @forum2.valid?
	end

	test "description should be present" do
		@forum2.description = "    "
		assert_not @forum2.valid?
	end

	test "name should be unique" do
		duplicate_forum = @forum2.dup
		@forum2.save
		assert_not duplicate_forum.valid?
	end

	test "has many topics" do
		# There are two topics created belonging to @forum1 in fixtures
		assert_equal 2, @forum1.topics.size
	end

end
