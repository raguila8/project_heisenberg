class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :get_comments]
	before_action :correct_comment, only: [:edit, :update, :destroy]

	def create
		@comment = Comment.new(comment_params)
		respond_to do |format|
			if @comment.save
				@saved = true
				if current_user != @comment.post.user
					@notification = Notification.new
					@notification.notified_by_id = current_user.id
					@notification.user_id = @comment.post.user_id
					@notification.post_id = @comment.post.id
					@notification.notification_type = "comment"
					@notification.save
				end

			else
				@saved = false
			end
	
			format.js {}
		end

	end

	def destroy
		comment = Comment.find(params[:id])
		if comment.user != current_user
			redirect_to topic_path(comment.post.topic.id)
		else
			@comment_id = comment.id
			comment.destroy
		end
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

	# Before action
	# Makes sure comment belongs to current_user
	def correct_comment
		comment = Comment.find(params[:id])
		redirect_to topic_path(comment.post.topic.id) unless comment.user == current_user
	end
	
	def comment_params
		params.require(:comment).permit(:content, :user_id, :post_id)
	end

	def update_comment_params
		params.require(:comment).permit(:content)
	end


end
