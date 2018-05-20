module ApplicationHelper

  def branch_icon(branch_name)
    branch_name.downcase.tr(" ", "_")
  end

	def landing_page?
		controller_name == 'static_pages' && action_name == 'landing_page'
	end

	def about_page?
		controller_name == 'static_pages' && action_name == 'about'
	end

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
	
	def bg_color(percentage)
		if percentage >= 80
			return "green-bg"
		elsif percentage >= 50
			return "orange-bg"
		else
			return "red-bg"
		end
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

	def set_edit_settings_class
		((controller_name == "users") && (action_name == "edit" || action_name == "update")) ? "active-effect-4" : "non-active-effect-4" 

	end

	def set_edit_password_class
		((devise_controller?) && (action_name == "update" || action_name == "edit")) ? "active-effect-4" : "non-active-effect-4" 
	end

	def set_edit_profile_class
		((controller_name == "users") && (action_name == "edit_profile" || action_name == "update_profile")) ? "active-effect-4" : "non-active-effect-4" 
	end

	def set_new_problem_class
		((controller_name == "problems") && (action_name == "new" || action_name == "create")) ? "active-effect-4" : "non-active-effect-4" 
	end

	def set_new_branch_class
		((controller_name == "branches") && (action_name == "new" || action_name == "create")) ? "active-effect-4" : "non-active-effect-4" 
	end

	def set_new_subtopic_class
		((controller_name == "subtopics") && (action_name == "new" || action_name == "create")) ? "active-effect-4" : "non-active-effect-4" 
	end

  def flash_messages
    if flash[:notice] || flash[:success]
      type = "success"
      msg = flash[:notice] ? flash[:notice] : flash[:success]
    elsif flash[:alert]
      type = "warning"
      msg = flash[:alert]
    else
      return
    end
    html = "<div class='flash-message text-center'>\n"
    html += "  <div class='flash-message-overlay #{type} text-center'>\n"
    html += %Q{    <span class='text-center'><img class='inline-icon g-mr-5' \
      src='/#{type}.png'> #{msg} </span>\n  </div>\n</div>}
    return html.html_safe
  end
end
