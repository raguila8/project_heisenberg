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
		@vote_type = params[:vote_type]
		@votable_type = params[:votable_type]
		if @votable_type == "post"
			@post = Post.find(params[:id])
			if @vote_type == "like"
				if !current_user.liked? @post
					@post.liked_by current_user
					@voted = true
				end
			else
				if !current_user.voted_down_on? @post
					@post.downvote_from current_user
					@voted = true
				end
			end
		else 
			@comment = Comment.find(params[:id])
			if @vote_type == "like"
				if !current_user.liked? @comment
					@comment.liked_by current_user
					@voted = true
				end
			else
				if !current_user.voted_down_on? @comment
					@comment.downvote_from current_user
					@voted = true
				end
			end
		end	

		respond_to do |format|
			format.js
			format.json
			format.html
		end
	
	end

end
