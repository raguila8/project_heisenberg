class BranchesController < ApplicationController
	def show
		@branch = Branch.find(params[:id])
	end

	def index

	end

	def problems_filter
		topics = params[:topics]
		difficulties = params[:difficulties]
		problem_status = params[:problem_status]
		branch = Branch.find(params[:branch_id])
		if logged_in?
			user_id = current_user.id
		else
			user_id = nil
		end
		@problems = branch.problems_filter(topics, problem_status, difficulties, user_id)
		
	end

	private

end
