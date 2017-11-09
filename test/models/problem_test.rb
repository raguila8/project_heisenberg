require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  
	def setup
		@problem = Problem.new(question: "What is 1 + 1?", answer: 2, 
												subject: "Addition", number: 1, difficulty: 1, 
												title: "Simple Addition")
		@user = users(:rodrigo)
		@problem2 = problems(:problem_one)
	end

	test "should be valid" do
		assert @problem.valid?
	end

	test "question should be present" do
		@problem.question = "     "
		assert_not @problem.valid?
	end

	test "answer should be present" do
		@problem.answer = "    "
		assert_not @problem.valid?
	end

	test "subject should be present" do
		@problem.subject = "     "
		assert_not @problem.valid?
	end

	test "title should be present" do
		@problem.title = "     "
		assert_not @problem.valid?
	end

	test "difficulty should be present" do
		@problem.difficulty = ""
		assert_not @problem.valid?
	end

	test "number should be present" do
		@problem.number = ""
		assert_not @problem.valid?
	end

	test "number should be a natural number" do
		@problem.number = 1.2
		assert_not @problem.valid?
		@problem.number = -2
		assert_not @problem.valid?
		@problem.number = "two"
		assert_not @problem.valid?
	end

	test "difficulty should be a natural number" do
		@problem.difficulty = 1.2
		assert_not @problem.valid?
		@problem.difficulty = -2
		assert_not @problem.valid?
		@problem.difficulty = "two"
		assert_not @problem.valid?
	end

	test "difficulty should be 1, 2 or 3" do
		@problem.difficulty = 4
		assert_not @problem.valid?
		@problem.difficulty = 0
		assert_not @problem.valid?
		3.times do |i|
			@problem.difficulty = i + 1
			assert @problem.valid?
		end
	end

	test "answer should be a number" do
		@problem.answer = "two"
		assert_not @problem.valid?
		@problem.answer = 2.33
		assert @problem.valid?
		@problem.answer = 2e10
		assert @problem.valid?
	end

	test "number should be unique" do
		duplicate_problem = Problem.new(question: "What is 2 + 2?", answer: 4, 
												subject: "Addition", number: 1, difficulty: 1, 
												title: "Simple Addition 2")
		@problem.save
		assert_not duplicate_problem.valid?
	end

	test "question should be unique" do
		duplicate_problem = Problem.new(question: "What is 1 + 1?", answer: 2, 
												subject: "Addition", number: 2, difficulty: 1, 
												title: "Simple Addition 2")
		@problem.save
		assert_not duplicate_problem.valid?
	end

	test "title should be unique" do
		duplicate_problem = Problem.new(question: "What is 2 + 2?", answer: 4, 
												subject: "Addition", number: 2, difficulty: 1, 
												title: "Simple Addition")
		@problem.save
		assert_not duplicate_problem.valid?
	end

	# Tests the has_many association with solved_problems
	test "should have many solved_problems" do
		# created two solved_problems belonging to @problem2 in fixtures
		assert_equal 2, @problem2.solved_problems.size
	end

	#Tests the has_one association with topics
	test "should have one topic" do
		assert_equal @problem2.id, @problem2.topic.problem_id
	end

	# Tests the has_many association with users through solved_problems. 
	# Essentially checks that you can find the users who have solved a particular
	# problem as follows: problem.users
	test "should have many users" do
		assert_equal 2, @problem2.users.size
	end
	
	# The solved_problems belonging to a destroyed problem should also
	# be destroyed
	test "solved_problems should be destroyed when problem is destroyed" do
		assert_equal 1, @user.solved_problems.size
		assert_equal @problem2.id, @user.solved_problems.first.problem_id
		@problem2.destroy
		assert_equal 0, @user.solved_problems.size
	end

	# The thread corresponding to a destoryed problem should also be destroyed
	test "Corresponging topic should be destroyed when problem is destroyed" do
		assert_equal 2, Topic.all.size
		@problem2.destroy
		assert 1, Topic.all.size
	end

end
