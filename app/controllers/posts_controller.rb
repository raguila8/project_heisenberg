class PostsController < ApplicationController
	before_action :logged_in_user, only: [:new, :create, :edit]

	def new
		@post = Post.new
	end

	def create
		if params[:commit] == "Cancel"
			redirect_to topic_path(params[:topic_id])
		elsif params[:commit] == "Preview Message"
			@post = Post.new(user_params)
			@post.user_id = current_user.id
			@post.topic_id = params[:topic_id]
			if @post.content.empty?
				@post.errors.add(:content, :blank, message: "can't be blank")
			end
			render 'new'
		elsif params[:commit] == "Post Message"
			@post = Post.new(user_params)
			@post.user_id = current_user.id
			@post.topic_id = params[:topic_id]
			if @post.save
				flash[:success] = "New post created!"
				redirect_to topic_path(@post.topic_id)
			else
				render 'new'
			end
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if params[:commit] == "Cancel"
			redirect_to topic_path(@post.topic_id)
		elsif params[:commit] == "Preview Message"
			if params[:post][:content].empty?
			#if @post.content.empty?
				@post.errors.add(:content, :blank, message: "Can't be blank")
			end
			@post.update_attributes(post_update_params)
			render 'edit'
		elsif params[:commit] == "Save Changes"
			if @post.update_attributes(post_update_params)
				flash[:success] = "Post Updated"
				redirect_to topic_path(@post.topic_id)
			else
				render 'edit'
			end
		end
	end

	def destroy 
		post = Post.find(params[:id])
		topic_id = post.topic_id
		post.destroy
		flash[:success] = "Your post was deleted"
		redirect_to topic_path(topic_id)
	end

	private

		def user_params
			params.require(:post).permit(:content)
		end

		def post_update_params
			params.require(:post).permit(:content)
		end

end

