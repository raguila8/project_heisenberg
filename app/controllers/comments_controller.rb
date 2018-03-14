class CommentsController < ApplicationController
	
	def create
		@comment = Comment.new(comment_params)
		respond_to do |format|
			if @comment.save
				@saved = true
			else
				@saved = false
			end
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
			format.js {}
		end

	end

	def destroy
		comment = Comment.find(params[:id])
		@comment_id = comment.id
		comment.destroy
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
	
	def edit
		@comment = Comment.find(params[:id])
	end

	def update
		@comment = Comment.find(params[:id])	
		@cancel = false
		if params[:commit] == "Cancel"
			@cancel = true
		elsif params[:commit] == "Update"
			@errors = false
			respond_to do |format|
				if @comment.update_attributes(update_comment_params)
					format.js {}
				else
					@errors = true
					format.json { render json: {errors: @errors, message: @comment.errors.full_messages.first }
					}
				end
			end
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:content, :user_id, :post_id)
	end

	def update_comment_params
		params.require(:comment).permit(:content)
	end


end
