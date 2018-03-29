class Branch < ApplicationRecord
	has_many :subtopics
	has_many :problems, through: :subtopics
	validates :name, presence: true, uniqueness: true

	def unique_topics
		topics = Subtopic.select('DISTINCT name').
							where("branch_id = #{self.id}")
		return topics
	end

	def problems_filter(topics, problem_status, difficulties, user_id)
		topics_ids = []
		if !topics.nil?
			topics.each do |t|
				topics_ids << "SELECT problem_id FROM subtopics
										WHERE name = #{ActiveRecord::Base.connection.quote(ActiveRecord::Base.connection.quote_string(t))}"
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

		filtered_problems = "SELECT * FROM problems INNER JOIN subtopics ON subtopics.problem_id = problems.id  WHERE subtopics.branch_id = #{self.id} "

		topics_ids.each_with_index do |ids, index|
			if index != topics_ids.length - 1
				if index == 0
					filtered_problems += "AND (problem_id IN (#{ids}) "
				else
					filtered_problems += "OR problem_id IN (#{ids}) "
				end
			else
				if index == 0
					filtered_problems += "AND (problem_id IN (#{ids})) "
				else
					filtered_problems += "OR problem_id IN (#{ids})) "
				end
			end
		end

		problem_status_ids.each_with_index do |ids, index|
			if index != problem_status_ids.length - 1
				if index == 0
					filtered_problems += "AND (problem_id IN (#{ids}) "
				else
					filtered_problems += "OR problem_id IN (#{ids}) "
				end
			else
				if index == 0
					filtered_problems += "AND (problem_id IN (#{ids})) "
				else

					filtered_problems += "OR problem_id IN (#{ids})) "
				end
			end
		end

		difficulties_ids.each_with_index do |ids, index|
			if index != difficulties_ids.length - 1
				if index == 0
					filtered_problems += "AND (problem_id IN (#{ids}) "
				else
					filtered_problems += "OR problem_id IN (#{ids}) "
				end
			else
				if index == 0
					filtered_problems += "AND (problem_id IN (#{ids}))"
				else
					filtered_problems += "OR problem_id IN (#{ids}))"
				end
			end
		end

		problems = Problem.find_by_sql(filtered_problems)
		return problems
	end
end
