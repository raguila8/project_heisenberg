class SolvedProblemsController < ApplicationController
	include SolvedProblemsHelper
	# Runs when user submits an answer
	def create
		@problem = Problem.find(params[:id])
		answer = params[:answer]
		@correct = false
		@error = ''
		@problem.submissions += 1
		@problem.save
		# answer validation for when it is empty
		if answer.empty?
			@error = "You left the answer box empty."
			#redirect_to @problem
		# Answer has to be a number. 
		elsif !is_number?(answer)
			@error = "Invalid input"
			#redirect_to @problem
		# wrong answer
		elsif !within_five_percent?(answer.to_f, @problem.answer.to_f)
			@error = "Sorry, but the answer you gave appears to be incorect."
			#redirect_to @problem
		# Right answer. Create a solved_problems row for current user and problem.
		# Increments user score.
		else
			@correct = true
			user = current_user
			@solved_problem = SolvedProblem.create(user_id: current_user.id, problem_id: @problem.id)
			#user.problems << @problem
			user.score += points_gained(@problem.difficulty)
			user.solved += 1
			user.save
			@problem.solved_by += 1
			@problem.save
		end
	end

	# Float raises an exception if arg is invalid so we send control to the
	# rescue clause
	def is_number?(str) 
		true if Float(str) rescue false
	end

	
	# points earned from answering question.
	def points_gained(difficulty)
		if difficulty == 1
			return 20
		elsif difficulty == 2
			return 40
		elsif difficulty == 3
			return 80
		end
	end
end
