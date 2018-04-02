class Comment < ApplicationRecord
	acts_as_votable
	belongs_to :user
  belongs_to :post
	has_many :notifications, dependent: :destroy

	validates :user, presence: true
	validates :post, presence: true
	validates :content, presence: true


end
