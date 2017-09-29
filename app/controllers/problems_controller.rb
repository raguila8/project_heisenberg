class ProblemsController < ApplicationController
	#before_action :logged_in_user, only: [:show]
	def index
		@problems = Problem.all.order(:id).paginate(page: params[:page], :per_page => 30)
		if logged_in? 
			@solved_problems = current_user.problems.order(:id)
		end
	end

	def show
		@problem = Problem.find(params[:id])
	end
	
	#def logged_in_user
		#unless logged_in?
			#flash[:danger] = "Please log in."
			#redirect_to login_url
		#end
	#end
end

