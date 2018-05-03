class Message < ApplicationRecord
	belongs_to :conversation
	belongs_to :user

	validates_presence_of :body, :conversation_id, :user_id
  validates :body, length: { maximum: 1000 }
	validate :validate_conversation_id
	validate :validate_user_id

	private

	def validate_conversation_id
		errors.add(:conversation_id, "is invalid") unless Conversation.exists?(self.conversation_id)
  end

	def validate_user_id
		errors.add(:user_id, "is invalid") unless User.exists?(self.user_id)
  end
end
