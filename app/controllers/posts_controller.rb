class PostsController < ApplicationController
	before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
	before_action :correct_post, only: [:edit, :update, :destroy]

	def new
		@post = Post.new
	end

	def create
		respond_to do |format|
			@post = Post.new(user_params)
			@post.user_id = current_user.id
			@post.topic_id = params[:topic_id].to_i
			@post_count = params[:post_count].to_i
			@errors = false;
			if @post.save
				format.js {}
			else
				# Bad request
				format.json { render json: {errors: @errors, message: @post.errors.full_messages.first }
				}
			end
		end
=begin
		if params[:commit] == "Cancel"
			redirect_to topic_path(params[:topic_id])
		elsif params[:commit] == "Preview Post"
			@post = Post.new(user_params)
			@post.user_id = current_user.id
			@post.topic_id = params[:topic_id]
			if @post.content.empty?
				@post.errors.add(:content, :blank, message: "can't be blank")
			end
			render 'new'
=end
	end

	def edit
		@post = Post.find(params[:id])
		@thread = Topic.find(@post.topic_id)
		@post_count = params[:post_count]
	end

	def update
		@post = Post.find(params[:id])
		@post_count = params[:post_count]
		@cancel = false
		if params[:commit] == "Cancel"
			@cancel = true
		elsif params[:commit] == "Update"
			@errors = false
			respond_to do |format|
				if @post.update_attributes(post_update_params)
					format.js {}
				else
					@errors = true
					format.json { render json: {errors: @errors, message: @post.errors.full_messages.first }
					}
				end
			end
		end
	end

	def destroy 
		post = Post.find(params[:id])
		@post_count = params[:post_count]
		#topic_id = post.topic_id
		post.destroy
		#flash[:success] = "Your post was deleted"
		#redirect_to topic_path(topic_id)
	end

	private

		# Before action
		# Makes sure post belongs to current_user
		def correct_post
			post = Post.find(params[:id])
			redirect_to topic_path(post.topic.id) unless post.user == current_user
		end

		def user_params
			params.require(:post).permit(:content)
		end

		def post_update_params
			params.require(:post).permit(:content)
		end

end

