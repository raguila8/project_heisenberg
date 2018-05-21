class Problem < ApplicationRecord
	has_many :solved_problems, :dependent => :destroy
	has_many :problem_categories, :dependent => :destroy
	has_many :subtopics, through: :problem_categories, :dependent => :destroy
	has_many :branches, through: :subtopics
	has_one :topic, :dependent => :destroy
	has_one :problem_attribution, :dependent => :destroy
	has_many :users, {:through => :solved_problems, :source => "user"}
	validates :question, presence: true
		#uniqueness: true
	validates :difficulty, presence: true, :numericality => 
							{ :greater_than => 0, :less_than_or_equal_to => 3,
								:only_integer => true }
	validates :title, presence: true, uniqueness: { case_sensitive: false }
	validates :answer, presence: true, :numericality => true

	# Gets the number of problems with a specific branch
	def self.branch_count(branch)
		count = Problem.select("p.id").
												joins("as p inner join problem_categories as pc on p.id = pc.problem_id").
												joins("inner join subtopics as st on st.id = pc.subtopic_id AND st.branch_id = #{branch.id}").distinct.count
		return count
	end

	# Returns the number of problems with a specific topic
	def self.topic_count(topic_name)
		count = Problem.select("p.id").joins("as p inner join problem_categories as pc on p.id = pc.problem_id").
					joins("inner join subtopics as st on st.id = pc.subtopic_id AND st.name = #{ActiveRecord::Base.connection.quote(ActiveRecord::Base.connection.quote_string(topic_name))}").count


#subtopics as st on p.id = st.problem_id AND st.name = #{ActiveRecord::Base.connection.quote(ActiveRecord::Base.connection.quote_string(topic_name))}").count
	return count
	end

	# Checks if the problem has been solved by user
	def solved?(user)
		if SolvedProblem.find_by(user_id: user.id, problem_id: self.id)
			return true
		else
			return false
		end
	end
end
