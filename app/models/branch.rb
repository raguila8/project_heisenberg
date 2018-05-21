class Branch < ApplicationRecord
	has_many :subtopics, :dependent => :destroy
	#has_many :problems, through: :problem_categories
	validates :name, presence: true, uniqueness: { case_sensitive: false }

	def unique_topics
		topics = Subtopic.select('DISTINCT name').
							where("branch_id = #{self.id}")
		return topics
	end

	def problems
		return Problem.
			joins("inner join problem_categories as pc on pc.problem_id = problems.id").
			joins("inner join subtopics as st on st.id = pc.subtopic_id AND st.branch_id = #{self.id}").distinct
	end

	def problems_filter(topics, problem_status, difficulties, user_id)
		topics_ids = []
		if !topics.nil?
			topics.each do |t|
				topics_ids << "SELECT problem_id FROM problem_categories as pc
						INNER JOIN subtopics as st on st.id = pc.subtopic_id 
						AND st.name = #{ActiveRecord::Base.connection.quote(t)}"


#"SELECT problem_id FROM subtopics
#										WHERE name = #{ActiveRecord::Base.connection.quote(ActiveRecord::Base.connection.quote_string(t))}"
			end
		end
		
		problem_status_ids = []
		if !user_id.nil? && !problem_status.nil?
			solved_problems = "SELECT problem_id FROM solved_problems
										WHERE user_id = #{user_id}"
			if problem_status.include? "solved"
				problem_status_ids << solved_problems
			end

			if problem_status.include? "unsolved"
				problem_status_ids << "SELECT id FROM problems
										WHERE id NOT IN (#{solved_problems})"

			end
		end

		difficulties_ids = []
		if !difficulties.nil?
			difficulties.each do |d|
				difficulties_ids << "SELECT id FROM problems
										WHERE difficulty = #{d}"
			end

		end
		filtered_problems = "INNER JOIN problem_categories as pc ON pc.problem_id = problems.id INNER JOIN subtopics as st ON st.id = pc.subtopic_id WHERE st.branch_id = #{self.id} "
		#filtered_problems = "SELECT * FROM problems INNER JOIN subtopics ON subtopics.problem_id = problems.id  WHERE subtopics.branch_id = #{self.id} "

		topics_ids.each_with_index do |ids, index|
			if index != topics_ids.length - 1
				if index == 0
					filtered_problems += "AND (pc.problem_id IN (#{ids}) "
				else
					filtered_problems += "OR pc.problem_id IN (#{ids}) "
				end
			else
				if index == 0
					filtered_problems += "AND (pc.problem_id IN (#{ids})) "
				else
					filtered_problems += "OR pc.problem_id IN (#{ids})) "
				end
			end
		end

		problem_status_ids.each_with_index do |ids, index|
			if index != problem_status_ids.length - 1
				if index == 0
					filtered_problems += "AND (pc.problem_id IN (#{ids}) "
				else
					filtered_problems += "OR pc.problem_id IN (#{ids}) "
				end
			else
				if index == 0
					filtered_problems += "AND (pc.problem_id IN (#{ids})) "
				else

					filtered_problems += "OR pc.problem_id IN (#{ids})) "
				end
			end
		end

		difficulties_ids.each_with_index do |ids, index|
			if index != difficulties_ids.length - 1
				if index == 0
					filtered_problems += "AND (pc.problem_id IN (#{ids}) "
				else
					filtered_problems += "OR pc.problem_id IN (#{ids}) "
				end
			else
				if index == 0
					filtered_problems += "AND (pc.problem_id IN (#{ids}))"
				else
					filtered_problems += "OR pc.problem_id IN (#{ids}))"
				end
			end
		end

		problems = Problem.joins(filtered_problems).distinct
		
		#problems = ActiveRecord::Base.connection.exec_query(filtered_problems).entries
		return problems
	end
end
