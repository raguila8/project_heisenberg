class TopicsController < ApplicationController
	before_action :logged_in_user, only: [:show, :vote]
	#respond_to :js, :json, :html
	def show
		@post = Post.new
		@thread = Topic.find(params[:id])
		@posts = @thread.posts.order(created_at: :desc)[0..9]
		#@posts = @thread.posts.paginate(page: params[:page], :per_page => 15)
		respond_to do |format|
			format.html { }
			format.js {
				@more = false;
				page = params[:page].to_i
				offset = page * 10 - 1
				@post_count = offset + 1 - 10
				@posts = @thread.posts.order(created_at: :desc)[(offset - 9)..offset]
				if @thread.posts.count > offset + 1
					@more = true
				end
			}
		end
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
