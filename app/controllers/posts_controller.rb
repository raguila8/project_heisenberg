class PostsController < ApplicationController
	before_action :logged_in_user, only: [:new, :create]

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

	private

		def user_params
			params.require(:post).permit(:content)
		end
end

