require 'test_helper'

class SolvedProblemTest < ActiveSupport::TestCase
	def setup
		@user = users(:archer)
		@problem = problems(:problem_one)
		@solved_problem1 = solved_problems(:solved_problem_one)
		@solved_problem2 = solved_problems(:solved_problem_two)
		@solved_problem3 = SolvedProblem.new(user_id: @user.id, 
																		problem_id: @problem.id)
	end

	test "should be valid" do
		assert @solved_problem3.valid?
	end

	test "should belong to a problem" do
		assert_not @solved_problem1.problem.nil?
		assert_not @solved_problem2.problem.nil? 
		assert_not @solved_problem3.problem.nil?
		assert_equal @solved_problem1.problem.id, @solved_problem2.problem.id
	end

	test "should belong to a user" do
		assert_not @solved_problem1.user.nil?
		assert_not @solved_problem2.user.nil? 
		assert_not @solved_problem3.user.nil?
	end

	test "user_id and problem_id pair should be unique" do
		duplicate_solved_problem = @solved_problem3.dup
		@solved_problem3.save
		assert_not duplicate_solved_problem.valid?
	end
end
