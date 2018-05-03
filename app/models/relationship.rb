class Relationship < ApplicationRecord
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	validates :follower_id, presence: true
	validates :followed_id, presence: true
  validate :follower_and_followed_not_equal

  # validates that follower and followed are not the same
  def follower_and_followed_not_equal
    if self.follower_id == self.followed_id
      errors.add(:follower_id, "cannot follow the follower")
    end
  end
end
