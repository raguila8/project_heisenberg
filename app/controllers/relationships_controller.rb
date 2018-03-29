class RelationshipsController < ApplicationController
	def create 
		followed = params[:followed]
		@user = User.find(followed)
		current_user.following << @user
=begin
		@notification = Notification.new
		@notification.notified_by_id = current_profile.id
		@notification.profile_id = @profile.id
		@notification.notification_type = "follower"
		@notification.save
=end
		respond_to do |format|
			format.js {}
		end
	end

	def destroy
		followed = params[:followed]
		@user = User.find(followed)
		current_user.unfollow(@user)
=begin
		@notification = Notification.find_by(:notified_by_id => current_profile.id,
																				:profile_id => @profile.id,
																				:notification_type => "follower")
		if @notification
			@notification.destroy
		end
=end
		respond_to do |format|
			format.js {}
		end
	end

end
