class ProblemAttribution < ApplicationRecord
	belongs_to :problem

	validates :source_type, presence: true, inclusion: { in: %w(book website) }
	validates :link, presence: true
	validates :title, presence: true
	
end
