class FriendshipsController < ApplicationController
	def destroy
		friend = User.find(params[:id])
		@friendship = current_user.friendships.where(friend_id: params[:id]).first
		@friendship.destroy
		respond_to do |format|
			format.html {
				flash[:success] = "#{friend.username} is no longer your friend"
				redirect_to friends_path
			}
		end
	end

	def create
		id = params[:id]
		user = User.find(id)
		current_user.friends << user
		respond_to do |format|
			format.html {
				flash[:success] = "#{user.username} is now your friend!"
				redirect_to friends_path
			}
		end
	end
end
