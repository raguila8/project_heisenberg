module ProblemsHelper
	def problems_to_display(user)
		SolvedProblem.where(user_id: user.id).order('created_at DESC').limit(10)
	end

	# Used to get the percentage of problems solved in a specific
	# category
	def percentage(problems_solved, problems_count)
		if problems_count == 0
			return 0
		else
			perc = (problems_solved.to_f / problems_count) * 100
		end
		return perc
	end
end
