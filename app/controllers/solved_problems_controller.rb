class SolvedProblemsController < ApplicationController
	def create
		@problem = Problem.find(params[:id])
		answer = params[:answer]
		if answer.empty?
			flash[:danger] = "You left the answer box empty."
			redirect_to @problem
		elsif !is_number?(answer)
			flash[:danger] = "Invalid input"
			redirect_to @problem
		elsif answer.to_f != @problem.answer.to_f
			flash[:danger] = "Sorry, but the answer you gave appears to be incorect."
			redirect_to @problem
		else
			user = current_user
			user.problems << @problem
			user.score += points_gained(@problem.difficulty)
			user.save
			@problem.solved_by += 1
			@problem.save
		end
	end

	def is_number?(str) 
		true if Float(str) rescue false
	end

	def points_gained(difficulty)
		difficulty * 20
	end
end
