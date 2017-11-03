class Problem < ApplicationRecord
	has_many :solved_problems
	has_one :topic, :dependent => :destroy
	has_many :users, {:through => :solved_problems, :source => "user"}
	validates :question, presence: true
	validates :subject, presence: true
	validates :difficulty, presence: true
	validates :title, presence: true
	validates :answer, presence: true, :numericality => true
end
