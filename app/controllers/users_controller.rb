class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :edit, :update, :show, :find_friends, :destroy]
	before_action :correct_user,	 only: [:edit, :update]
	before_action :admin_user, only: :destroy

	def index
		@friendships = current_user.friends.paginate(page: params[:page])
	end

	def find_friends
		if params[:search]
			@users = User.where("username like ?", 
				"%#{params[:search]}%").paginate(page: params[:page], :per_page => 10)
		else
			@users = User.all_except(current_user).paginate(page: params[:page], :per_page => 10)
		end

	end

	def show
		@user = User.find(params[:id])
		@problems = @user.problems.order(:id)
		@kudos = user_kudos(@user)
		@problems_solved = @user.solved_problems.order(created_at: :desc).limit(10)
	end

  def new
		@user = User.new
  end

	def create
		@user = User.new(user_params)		
		if @user.save
			log_in @user
			flash[:success] = "Welcome to Project Heisenberg!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		if @user.update_attributes(user_update_params)
			# Handle a successful update
			flash[:success] = "Profile update"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to find_friends_path
	end

	def leaderboards
		@users = User.paginate(page: params[:page], :per_page => 10).order(score: :desc)
		if logged_in?
			@my_rank = User.all.order(score: :desc).pluck(:id).index(current_user.id)
			@my_rank = @my_rank + 1 
		end
	end

	def leaderboard_filter
		branches = params[:branches]
		leaderboard = params[:leaderboard]
		users = params[:users]
		if logged_in?
			@users = User.filter_ranks(branches, users, leaderboard, current_user)
		
			@my_rank = @users.index(@users.detect { |user| user["id"] == current_user.id }) + 1
			@score = @users[@my_rank - 1]["score"]
			@users = @users.paginate(page: params[:page], :per_page => 10)
		else
			@users = User.filter_ranks(branches, users, leaderboard).paginate(page: params[:page], :per_page => 10)
		end
	end

  private

		def user_params
			params.require(:user).permit(:username, :email, :password, 
																		:password_confirmation)
		end

		def user_update_params
			params.require(:user).permit(:username, :email, :password, 
																		:password_confirmation, :country)
		end

		# Before filters

		# Confirm a looped-in user.	
		#def logged_in_user
		#	unless logged_in?
		#		flash[:danger] = "Please log in."
		#		redirect_to login_url
		#	end
		#end

		# Confrims the correct user.
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless @user == current_user
		end

		def user_kudos(user)
			kudos = 0
			user.posts.each do |post|
				kudos += post.cached_votes_score
			end
			user.comments.each do |comment|
				kudos += comment.cached_votes_score
			end
			return kudos
		end

		# Confirms an admin user.
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
end
