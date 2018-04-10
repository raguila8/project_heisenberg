class Subtopic < ApplicationRecord
	belongs_to :branch
	has_many :problems, through: :problem_categories
	validates :name, presence: true
	validates :branch_id, presence: true
	validates_uniqueness_of :name, :scope => [:branch_id]
end
