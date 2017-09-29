class Conversation < ApplicationRecord
	belongs_to :sender, :class_name => 'User'
	belongs_to :recipient, :class_name => 'User'

	has_many :messages, dependent: :destroy

	validates_uniqueness_of :sender_id, :scope => :recipient_id

	scope :between, -> (sender_id,recipient_id) do
 		where('(sender_id =? AND recipient_id =?) OR (sender_id =? AND recipient_id =?)', sender_id,recipient_id, recipient_id, sender_id)
 	end
end
