class SubtopicsController < ApplicationController
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
