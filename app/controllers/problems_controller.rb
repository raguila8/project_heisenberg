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
		@problem = Problem.find(params[:id])
	end

	def update 
		@problem = Problem.find(params[:id])
		difficulty = @problem.difficulty
		if params[:commit] == "Cancel"
			redirect_to archives_path
		elsif params[:commit] == "Preview Problem"
			if params[:problem][:question].empty?
			#if @post.content.empty?
				@problem.errors.add(:question, :blank, message: "Can't be blank")
			end
			@problem.update_attributes(problem_params)
			render 'edit'
		elsif params[:commit] == "Save Changes"
			if @problem.update_attributes(problem_params)
				if @problem.difficulty != difficulty
					@problem.users.each do |user|
						user.score -= points_gained(difficulty)
						user.score += points_gained(@problem.difficulty)
						user.save
					end
				end
				flash[:success] = "Problem Updated"
				redirect_to problem_path(@problem.id)
			else
				render 'edit'
			end
		end

	end

	def new
		@problem = Problem.new
	end

	def create
		if Problem.count > 0
			lastNumber = (Problem.last).number
		else
			lastNumber = 0
		end
		if params[:commit] == "Cancel"
			redirect_to root_path
		elsif params[:commit] == "Preview Problem"
			@problem = Problem.new(problem_params)
			if @problem.question.empty?
				@problem.errors.add(:question, :blank, message: "Can't be blank")
			end
			render 'new'
		elsif params[:commit] == "Create Problem"
			@problem = Problem.new(problem_params)
			@problem.number = lastNumber + 1
			# Answer Thread
			@topic1 = Topic.new
			#@topic.problem_id = @problem.id
			@topic1.name = "Problem #{@problem.number}"
			@topic1.forum_id = 1
			if @problem.save
				@topic1.problem_id = @problem.id
				@topic1.save
				flash[:success] = "New Problem created!"
				redirect_to archives_path
			else
				render 'new'
			end
		end
	end

	# deletes problem
	def destroy 
		problem = Problem.find(params[:id])
		problems = Problem.where("id > #{problem.id}")
		problems.each do |p|
			p.number -= 1
			p.save
			p.topic.name = "Problem #{p.number}"
			p.topic.save
		end
		problem.destroy
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

		def problem_params
			params.require(:problem).permit(:question, :subject, :difficulty, :title, :answer)
		end

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

