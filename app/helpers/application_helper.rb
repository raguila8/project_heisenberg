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
