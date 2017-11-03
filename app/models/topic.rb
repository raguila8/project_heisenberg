class Topic < ApplicationRecord
	belongs_to :forum
	has_many :posts, :dependent => :destroy
	belongs_to :problem
end
