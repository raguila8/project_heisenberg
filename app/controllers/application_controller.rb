class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	include SessionsHelper
=begin
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
		html += "<span style=\"float:right; font-size:85%;\">" +
						"#{message.created_at.strftime("%a, %d %b %Y, %I:%M %p")}</span>"
		html += "<br>"
		if my_message?(message)
			html += "<span class=\"glyphicon glyphicon-ok\"></span>"
		end
		html +=	"<span>#{message.body[0...25]}...</span>"
	end
=end
end
