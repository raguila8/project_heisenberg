class Notification < ApplicationRecord
	belongs_to :user, class_name: "User"
	belongs_to :notified_by, class_name: "User"
	belongs_to :post, class_name: "Post", optional: true
	belongs_to :comment, class_name: "Comment", optional: true
	validates :user_id, presence: true
	validates :notified_by_id, presence: true
	validates :notification_type, presence: true, inclusion: { in: %w(comment follower) }
	
	validate :validate_following_notification

	def validate_following_notification
		if self.notification_type == "follower"
			notification = Notification.find_by(:notified_by_id => self.notified_by_id,
																				:user_id => self.user_id,
																				:notification_type => "follower")
			
			if notification && notification != self
				errors.add(:user_id, "has already been followed")
			end
		end
	end
end
