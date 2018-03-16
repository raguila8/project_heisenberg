module ProblemsHelper
	def problems_to_display(user)
		SolvedProblem.where(user_id: user.id).order('created_at DESC').limit(10)
	end

end
