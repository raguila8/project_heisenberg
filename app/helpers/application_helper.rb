module ApplicationHelper

	def my_message?(message)
		current_user.id == message.user_id
	end

	def other_user(conversation)
		if current_user.id == conversation.sender_id
			return conversation.recipient
		end
		return conversation.sender
	end

	def unreadMessagesCount(conversations)
		count = 0
		conversations.each do |conversation|
			message = conversation.messages.order(updated_at: :desc).first
			next if message.nil?
			if !message.read
				count += 1
			end
		end
		return count
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
	
	def color(percentage)
		if percentage >= 80
			return "green"
		elsif percentage >= 50
			return "orange"
		else
			return "red"
		end
	end


	def notifications(conversation, message)
		html = ""
		html += "<span style=\"float:left; font-weight:bold;font-size:85%;\">" +
						"#{other_user(conversation).username}</span>"
		
		html += "<span style=\"float:right; font-size:70%;\">" +
						"#{message.created_at.strftime("%d %b %Y")}</span>"
		html += "<br>"
		if my_message?(message)
			html += "<span class=\"glyphicon glyphicon-ok\"style=\"font-size:60%;\"></span>&nbsp; &nbsp;"
		end
		html +=	"<span>#{message.body[0...25]}...</span>"
	end

end
