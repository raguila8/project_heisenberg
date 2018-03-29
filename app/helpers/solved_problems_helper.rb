module SolvedProblemsHelper
	# checks if answer is at most 5% error
	def within_five_percent?(answer, actual_answer)
		range = actual_answer * 0.05
		lowerBound = actual_answer - range
		upperBound = actual_answer + range
		if lowerBound <= answer && upperBound >= answer
			return true
		else
			return false
		end
	end

end
