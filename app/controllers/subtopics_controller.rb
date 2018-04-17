class SubtopicsController < ApplicationController
	before_action :logged_in_user, only: [:new, :create]
	before_action :admin_user, only: [:new, :create]

	def show
		
	end

	def new
		@subtopic = Subtopic.new
	end

	def create
		@subtopic = Subtopic.new(subtopic_params)
		if @subtopic.save
			flash[:success] = "New subtopic created!"
			redirect_to branch_path(@subtopic.branch)
		else
			render 'new'
		end
	end

	private

	def subtopic_params
		params.require(:subtopic).permit(:name, :branch_id)
	end

end
