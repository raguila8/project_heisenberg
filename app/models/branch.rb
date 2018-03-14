class Branch < ApplicationRecord
	has_many :subtopics
	has_many :problems, through: :subtopics
	validates :name, presence: true, uniqueness: true
end
