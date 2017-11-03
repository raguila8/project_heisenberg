class ProblemsController < ApplicationController
	#before_action :logged_in_user, only: [:show]
	# User must be an admin in order to destoy, edit, update or create problems.
	before_action :admin_user, only: [:destroy, :edit, :create, :new, :update]

	# displays all problems in database. If the user is signed in, user can
	# see whether or not they have solved certain problems.
	def index
		@problems = Problem.all.order(:id).paginate(page: params[:page], :per_page => 30)
		if logged_in? 
			@solved_problems = current_user.problems.order(:id)
		end
	end

	# displays question
	def show
		@problem = Problem.find(params[:id])
	end

	def edit

	end

	def update 

	end

	def new

	end

	def create

	end

	# deletes problem
	def destroy 
		Problem.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to archives_path
	end

	private
	
	#def logged_in_user
		#unless logged_in?
			#flash[:danger] = "Please log in."
			#redirect_to login_url
		#end
	#end

		# Confirms an admin user.
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end

end

