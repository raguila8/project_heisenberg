class ProblemsController < ApplicationController
	#before_action :logged_in_user, only: [:show]
	# User must be an admin in order to destoy, edit, update or create problems.
	before_action :admin_user, only: [:destroy, :edit, :create, :new, :update]

	# displays all problems in database. If the user is signed in, user can
	# see whether or not they have solved certain problems.
	def index
		@branches = Branch.all
		@problems = Problem.all.order(:id).paginate(page: params[:page], :per_page => 30)
		if signed_in? 
			@solved_problems = current_user.problems.order(:id)
		end
	end

	# displays question
	def show
		@problem = Problem.find(params[:id])
	end

	def edit
		@problem = Problem.find(params[:id])
		@problem_attribution = @problem.problem_attribution
	end

	def update
		@problem = Problem.find(params[:id])
		subtopics = @problem.subtopics
		dif = @problem.difficulty
		@problem.assign_attributes(problem_params)
		
		if @problem.valid?
			if params[:subtopic]
				params[:subtopic].each do |id|
					if !Subtopic.exists?(id)
						flash[:error] = "Subtopic selected does not exist"
						render 'new' and return
					end
				end

				if params[:problem_attribution][:update] == "yes"
					@problem_attribution = ProblemAttribution.assign_attributes(problem_attribution_params)
					if !["book", "website"].include?(@problem_attribution.source_type)
						flash[:error] = "Source Type must either be 'book' or 'website'."
						render 'edit' and return
					elsif @problem_attribution.link.blank?
						flash[:error] = "Link cannot be blank."
						render 'edit' and return
					elsif @problem_attribution.title.blank?
						flash[:error] = "Title cannot be blank."
						render 'edit' and return
					elsif @problem_attribution.source_type == "book" && @problem_attribution.author.blank?
						flash[:error] = "Problem Attribution must include an author"
						render 'edit' and return
					end
				end	

				if @problem.difficulty != dif
					@problem.points = points_gained(@problem.difficulty)
					old_points = points_gained(dif)
					@problem.users.each do |user|
						user.score -= old_points
						user.score += @problem.points
						user.save
					end
				end

				@problem.save
				@problem_attribution.save


				subtopics.each do |subtopic|
					if !params[:subtopic].include?(subtopic.id.to_s)
						ProblemCategory.find_by(problem_id: @problem.id, subtopic_id: subtopic.id).destroy
					end
				end

				params[:subtopic].each do |id|
					if !subtopics.include?(Subtopic.find(id))
						ProblemCategory.create(problem_id: @problem.id, subtopic_id: id)
					end
				end
	
				redirect_to dashboard_path
				return
			else
				flash[:error] = "No subtopic selected"
				render 'new' and return
			end
		else
			render 'new' and return
		end




=begin
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
=end
	end

	def new
		@problem = Problem.new
	end

	def create
		@problem = Problem.new(problem_params)
		if @problem.valid?
			if params[:subtopic]
				params[:subtopic].each do |id|
					if !Subtopic.exists?(id)
						flash[:error] = "Subtopic selected does not exist"
						render 'new' and return
					end
				end
				if params[:problem_attribution][:create] == "yes"
					@problem_attribution = ProblemAttribution.new(problem_attribution_params)
					if !["book", "website"].include?(@problem_attribution.source_type)
						flash[:error] = "Source Type must either be 'book' or 'website'."
						render 'new' and return
					elsif @problem_attribution.link.blank?
						flash[:error] = "Link cannot be blank."
						render 'new' and return
					elsif @problem_attribution.title.blank?
						flash[:error] = "Title cannot be blank."
						render 'new' and return
					elsif @problem_attribution.source_type == "book" && @problem_attribution.author.blank?
						flash[:error] = "Problem Attribution must include an author"
						render 'new' and return
					end
				end

				@problem.points = points_gained(@problem.difficulty)

				@problem.save
				@problem_attribution.problem_id = @problem.id
				@problem_attribution.save
				params[:subtopic].each do |id|
					ProblemCategory.create(problem_id: @problem.id, subtopic_id: id)
				end

				# Discussion Thread
				@topic = Topic.new
				@topic.problem_id = @problem.id
				@topic.name = @problem.title
				@topic.forum_id = 1
				@topic.save

				redirect_to dashboard_path
				return
			else
				flash[:error] = "No subtopic selected"
				render 'new' and return
			end
		else
			render 'new' and return
		end
	end

	# deletes problem
	def destroy 
		problem = Problem.find(params[:id])
		problem.users.each do |user|
			user.score = user.score - problem.points
			user.solved = user.solved - 1
			user.save
		end
		problem.destroy
		flash[:success] = "User deleted"
		redirect_to dashboard_path
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
			params.require(:problem).permit(:question, :difficulty, :title, :answer)
		end

		def problem_attribution_params
			params.require(:problem_attribution).permit(:source_type, :author, :link, :title)
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

