class ConversationsController < ApplicationController
	before_action :logged_in_user, only: [:create, :show]
	before_action :correct_conversation, only: [:show]

	def create
		sender = current_user
		@conversation = Conversation.new()
		if Conversation.between(sender.id, params[:recipient_id]).present?
			@conversation = Conversation.between(sender.id, params[:recipient_id]).first
		else
			@conversation = Conversation.create!(sender_id: sender.id, recipient_id: params[:recipient_id])
		end
		

		redirect_to conversation_path(@conversation.id)
	end

	def show
		@conversation = Conversation.find(params[:id])
		@messages = @conversation.messages
		@messages.each do |message|
			message.read = true
			message.save
		end
		@message = Message.new
		@conversations = Conversation.where("sender_id = #{current_user.id} OR recipient_id = #{current_user.id}").order(updated_at: :desc)
	end

	def index
		@conversations = Conversation.where("sender_id = #{current_user.id} OR recipient_id = #{current_user.id}").order(updated_at: :desc)
	end

	def correct_conversation
		@conversation = Conversation.find(params[:id])
		redirect_to(root_url) unless (current_user.id == @conversation.sender_id || current_user.id == @conversation.recipient_id)
	end
end

