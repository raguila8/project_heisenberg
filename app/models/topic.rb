class Topic < ApplicationRecord
	belongs_to :forum
	has_many :posts, :dependent => :destroy
	belongs_to :problem

	validates :name, presence: true, length: { maximum: 150 }
	validates :forum_id, presence: true
	validates :problem_id, uniqueness: true
  validates_uniqueness_of :name, :scope => [:forum_id]
end
