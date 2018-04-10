class ProblemCategory < ApplicationRecord
	belongs_to :subtopic
	belongs_to :problem
end
