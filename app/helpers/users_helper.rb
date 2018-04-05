module UsersHelper
	def put_info(user, problem, solved)
		html = "<p style=\"font-weight:bold;\">Problem #{problem.id} (solved by #{pluralize(problem.solved_by, "member")})</p>"
		html += "<p style=\"font-size:85%;font-weight:bold;\">Difficulty rating:" +
							" <span class=\"glyphicon glyphicon-star\"></span>" * 
								problem.difficulty + 
								"<span class=\"glyphicon glyphicon-star-empty\"></span>" *
								(3 - problem.difficulty) +
							"</p>"
		if solved
			html += "<p style=\"font-size:85%\">Completed on " + 
								SolvedProblem.find_by(problem_id: problem.id, 
																		user_id: user.id).created_at.strftime("%a, 
																												%d %b %Y, %I:%M %p") +
								"</p>"
		end
		html += "<p>" + problem.title + "</p>"
		return html
	end

	def search(pattern)
		if Rails.env.development? || Rails.env.test?
			users_query = "(SELECT users.username AS label, users.id AS id, 'Users' AS category, '/default_profile_image.png' AS image_url FROM users WHERE users.username LIKE '#{pattern}' LIMIT 5) "
			problems_query = "(SELECT problems.title AS label, problems.id AS id, 'Problems' AS category, '/problem_icon.png' AS image_url FROM problems WHERE problems.title LIKE '#{pattern}' LIMIT 5)"
		else
			users_query = "(SELECT users.username AS label, users.id AS id, 'Users' AS category, cast('/default_profile_image.png' as text) AS image_url FROM users WHERE users.username LIKE '#{pattern}' LIMIT 5) "
			problems_query = "(SELECT problems.title AS label, problems.id AS id, 'Problems' AS category, cast('/problem_icon.png' as text) AS image_url FROM problems WHERE problems.title LIKE '#{pattern}' LIMIT 5)"
		end
		query = "SELECT * FROM #{users_query} AS users_query UNION SELECT * FROM #{problems_query} AS problems_query"
		suggestions = ActiveRecord::Base.connection.execute(query)
		return suggestions
	end
end
