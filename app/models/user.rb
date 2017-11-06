class User < ApplicationRecord
	acts_as_voter
	has_many :friendships, dependent: :destroy
	has_many :friends, through: :friendships
	has_many :solved_problems, dependent: :destroy
	has_many :problems, {:through => :solved_problems, :source => "problem"}
	has_many :posts, dependent: :destroy
	has_many :messages, dependent: :destroy
	attr_accessor :remember_token
	before_save { self.email = email.downcase }
	before_save { self.country = country.downcase }
	validates :username, presence: true, length: { maximum: 25 },
											uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
										format: { with: VALID_EMAIL_REGEX }, 
										uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	def friends?(user)
		self.friends.include? user
	end

	scope :all_except, -> (user) do 
		where.not(id: user) && where.not(id: user.friends.select(:id))
	end

end
