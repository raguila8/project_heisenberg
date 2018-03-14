class Subtopic < ApplicationRecord
	belongs_to :branch
	belongs_to :problem
	validates_uniqueness_of :problem_id, :scope => [:branch_id, :name]
	validates :name, presence: true
end
