class UsersController < ApplicationController
	include UsersHelper
	before_action :logged_in_user, only: [:edit, :update, :show, :update_profile_image, :edit_profile, :update_profile, :destroy]
	before_action :correct_user,	 only: [:edit, :update, :update_profile, :edit_profile]
	before_action :admin_user, only: :destroy

=begin
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
=end

	def show
		@user = User.find(params[:id])
		@problems = @user.problems.order(:id)
		@kudos = user_kudos(@user)
		@problems_solved = @user.solved_problems.order(created_at: :desc).limit(10)
	end

=begin
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
=end

	def edit
		@user = User.find(params[:id])
	end

	def update
		if @user.update_attributes(user_settings_params)
			# Handle a successful update
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end


	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to root_path
	end


	def leaderboards
		@users = User.paginate(page: params[:page], :per_page => 10).order(score: :desc)
		if signed_in?
			@my_rank = User.all.order(score: :desc).pluck(:id).index(current_user.id)
			@my_rank = @my_rank + 1 
		end
	end

	def leaderboard_filter
		branches = params[:branches]
		leaderboard = params[:leaderboard]
		users = params[:users]
		if signed_in?
			@users = User.filter_ranks(branches, users, leaderboard, current_user)
		
			@my_rank = @users.index(@users.detect { |user| user["id"] == current_user.id })

			if @my_rank
				@my_rank += 1
				@score = @users[@my_rank - 1]["score"]
			else
				@my_rank = @users.count + 1
				@score = 0
			end
			@users = @users.paginate(page: params[:page], :per_page => 10)
		else
			@users = User.filter_ranks(branches, users, leaderboard).paginate(page: params[:page], :per_page => 10)
		end
	end

	def autocomplete
		respond_to do |format|
			format.json {
				@suggestions = search("%#{params[:query]}%")
				render json: {suggestions: @suggestions }
			}
		end
	end

	def recently_solved_problems
		@user = User.find(params[:user_id])
		page = params[:page].to_i
		@more = false
		respond_to do |format|
			if @user && !page.nil?	
				format.js {
					offset = page * 10 - 1
					solved_problems = @user.solved_problems
					
					@problems_solved = solved_problems.order(created_at: :desc)[(offset - 9)..offset].reverse
					if solved_problems.size > offset + 1
						@more = true
					end
				}
			end
		end
	end

	def update_profile_image
		if current_user.update_attributes(profile_image_update_params)
			# Handle a successful update
			flash[:success] = "Profile image updated"
		else
			#redirect_to edit_profile_path(@profile.id)
			flash[:error] = "profile image did not update"
		end

		if params[:path] == 'show'
			redirect_to current_user
		end
	end

	def edit_profile
		@user = User.find(params[:id])
	end

	def update_profile
		@user = User.find(params[:id])
		if @user.update_attributes(user_profile_params)
			# Handle a successful update
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit_profile'
		end
	end

  private

		def profile_image_update_params
			params.require(:user).permit(:profile_image)
		end


		def user_params
			params.require(:user).permit(:username, :email, :password, 
																		:password_confirmation)
		end

		def user_settings_params
			params.require(:user).permit(:username, :email)
		end

		def user_profile_params
			params.require(:user).permit(:name, :occupation, :school, :bio, :country)
		end


		# Before filters
=begin
		# Confirm a looped-in user.	
		def logged_in_user
			unless logged_in?
				flash[:danger] = "Please log in."
				redirect_to new_user_session_path
			end
		end
=end
=begin
		# Confrims the correct user.
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless @user == current_user
		end
=end
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
=begin
		# Confirms an admin user.
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
=end
end
