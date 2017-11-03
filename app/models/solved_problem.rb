class SolvedProblem < ApplicationRecord
	belongs_to :user
	belongs_to :problem
	#has_many :problems
	#has_many :users
end
