class Post < ApplicationRecord
	belongs_to :topic
	belongs_to :user
	validates :content, presence: true
	acts_as_votable
end
