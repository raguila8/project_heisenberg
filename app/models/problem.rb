class Problem < ApplicationRecord
	has_many :solved_problems, :dependent => :destroy
	has_one :topic, :dependent => :destroy
	has_many :users, {:through => :solved_problems, :source => "user"}
	validates :question, presence: true, uniqueness: true
	validates :subject, presence: true
	validates :difficulty, presence: true, :numericality => 
							{ :greater_than => 0, :less_than_or_equal_to => 3,
								:only_integer => true }
	validates :title, presence: true, uniqueness: true
	validates :answer, presence: true, :numericality => true
	validates :number, presence: true, :numericality => { :greater_than => 0, :only_integer => true }, uniqueness: true
end
