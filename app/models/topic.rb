class Topic < ApplicationRecord
	belongs_to :forum
	has_many :posts, :dependent => :destroy
	belongs_to :problem

	validates :name, presence: true, uniqueness: true
	validates :forum_id, presence: true
	validates :problem_id, uniqueness: true
end
