class Forum < ApplicationRecord	
  has_many :topics, :dependent => :destroy
  validates :name, presence: true, length: { maximum: 70, minimum: 3 },
                   uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { maximum: 150, minimum: 10 }
end
