class CommentsController < ApplicationController
	
	def create
		@comment = Comment.new(comment_params)
		respond_to do |format|
			if @comment.save
=begin
					if current_profile != @comment.post.profile
						@notification = Notification.new
						@notification.notified_by_id = current_profile.id
						@notification.profile_id = @comment.post.profile_id
						@notification.post_id = @comment.post.id
						@notification.notification_type = "comment"
						@notification.save
					end
=end
				format.html {
					#flash[:success] = "New comment posted!"
					#redirect_to home_path
				}
				format.json { 
					render json: @comment 
				}
				format.js {
			
				}
			end	
		end

	end

	def destroy

	end

	def get_comments
		@post = Post.find(params[:post_id])
		page = params[:page].to_i
		@more = false
		respond_to do |format|
			if @post && !page.nil?
				format.json {
					offset = page * 5 - 1
					all_comments = @post.comments
					comments = all_comments.order(created_at: :desc)[(offset - 4)..offset]
					if all_comments.size > offset + 1
						@more = true
					end
					render json: {comments: comments, more: true}
				}

				format.js {
					@post = Post.find(params[:post_id])
					page = params[:page].to_i
		@more = false

					offset = page * 5 - 1
					all_comments = @post.comments
					@comments = all_comments.order(created_at: :desc)[(offset - 4)..offset].reverse
					if all_comments.size > offset + 1
						@more = true
					end
				}
			end
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:content, :user_id, :post_id)
	end


end
