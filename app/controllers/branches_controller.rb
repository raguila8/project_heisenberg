class BranchesController < ApplicationController
	before_action :logged_in_user, only: [:new, :create]
	before_action :admin_user, only: [:new, :create]

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
		if signed_in?
			user_id = current_user.id
		else
			user_id = nil
		end
		@problems = branch.problems_filter(topics, problem_status, difficulties, user_id)
		
	end

	def new
		@branch = Branch.new
	end

	def create
		@branch = Branch.new(branch_params)
		if @branch.save
			flash[:success] = "New branch created!"
			redirect_to dashboard_path
		else
			render 'new'
		end
	end

	private


	def branch_params
		params.require(:branch).permit(:name)
	end

end
