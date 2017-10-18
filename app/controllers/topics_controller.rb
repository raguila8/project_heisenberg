class TopicsController < ApplicationController
	before_action :logged_in_user, only: [:show, :vote]
	#respond_to :js, :json, :html
	def show
		@thread = Topic.find(params[:id])
		@posts = @thread.posts.paginate(page: params[:page], :per_page => 15)
	end

	def vote
		@post = Post.find(params[:post])
		if !current_user.liked? @post
			@post.liked_by current_user
		elsif current_user.liked? @post
			@post.unliked_by current_user
		end

		respond_to do |format|
			format.js
			format.json
			format.html
		end
	
	end

end
