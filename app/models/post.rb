class Post < ApplicationRecord
	belongs_to :topic
	belongs_to :user
	has_many :comments, dependent: :destroy
	has_many :notifications, dependent: :destroy

	validates :content, presence: true, length: { maximum: 5000, minimum: 3 }
	validates :user_id, presence: true
	validates :topic_id, presence: true
	acts_as_votable
end
