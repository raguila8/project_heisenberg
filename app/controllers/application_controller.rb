class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	include SessionsHelper

	before_action :get_conversations
	
	def get_conversations
		if signed_in?
			@conversations = Conversation.where("sender_id = #{current_user.id} OR recipient_id = #{current_user.id}").order(updated_at: :desc)
		end
	end

	
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
