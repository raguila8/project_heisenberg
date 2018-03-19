class Conversation < ApplicationRecord
	belongs_to :sender, :class_name => 'User'
	belongs_to :recipient, :class_name => 'User'

	has_many :messages, dependent: :destroy

	validates_presence_of :sender_id, :recipient_id

	validates_uniqueness_of :sender_id, :scope => :recipient_id

	validate :validate_sender_id
	validate :validate_recipient_id

	scope :between, -> (sender_id,recipient_id) do
 		where('(sender_id =? AND recipient_id =?) OR (sender_id =? AND recipient_id =?)', sender_id,recipient_id, recipient_id, sender_id)
 	end

	private

	def validate_recipient_id
		errors.add(:recipient_id, "is invalid") unless User.exists?(self.recipient_id)
  end

	def validate_sender_id
		errors.add(:sender_id, "is invalid") unless User.exists?(self.sender_id)
  end

	public

	def other_user(user)
		if self.sender_id == user.id
			return User.find(self.reipient_id)
		else
			return User.find(sender_id)
		end
	end


end
