class RelationshipsController < ApplicationController
	def create 
		followed = params[:followed]
		@user = User.find(followed)
		current_user.following << @user
		@notification = Notification.new
		@notification.notified_by_id = current_user.id
		@notification.user_id = @user.id
		@notification.notification_type = "follower"
		@notification.save

		respond_to do |format|
			format.js {}
		end
	end

	def destroy
		followed = params[:followed]
		@user = User.find(followed)
		current_user.unfollow(@user)

		@notification = Notification.find_by(:notified_by_id => current_user.id,
																				:user_id => @user.id,
																				:notification_type => "follower")
		if @notification
			@notification.destroy
		end

		respond_to do |format|
			format.js {}
		end
	end

end
