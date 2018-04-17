class NotificationsController < ApplicationController
	before_action :logged_in_user, only: [:read_notifications]

	def read_notifications		
		if current_user.notifications.count > 0
			current_user.notifications.each do |notification|
				if notification.read == false
					notification.update_attributes(:read => true)
				end
			end
		end
	end
end
