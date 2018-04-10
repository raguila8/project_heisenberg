class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	acts_as_voter
	mount_uploader :profile_image, ProfileImageUploader
	has_many :active_relationships, class_name: "Relationship",
																	foreign_key: "follower_id",
																	dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship",
																	foreign_key: "followed_id",
																	dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	has_many :notifications, dependent: :destroy
	has_many :solved_problems, dependent: :destroy
	has_many :problems, {:through => :solved_problems, :source => "problem"}
	has_many :posts, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :messages, dependent: :destroy
	#attr_accessor :remember_token
	before_save { self.email = email.downcase }
	validates :username, presence: true, length: { minimum: 5, maximum: 18 },
											uniqueness: true
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
										uniqueness: { case_sensitive: false }
	#has_secure_password
	#validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
	validate :profile_image_size


	# Follows a user
	def follow(other_user)
		self.following << other_user
	end

	# Unfollows a user
	def unfollow(other_user)
		self.following.delete(other_user)
	end

	# Returns true if the current user is following the other user.
	def following?(other_user)
		self.following.include?(other_user)
	end


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

	# Returns the number of solved problems in a branch
	def branch_problems_solved(branch)
		problems = SolvedProblem.select("ps.problem_id").
							where("ps.user_id = #{self.id}").
							joins("as ps inner join problem_categories as pc on ps.problem_id = pc.problem_id").
							joins("inner join subtopics as st on pc.subtopic_id = st.id AND st.branch_id = #{branch.id}")
		return problems.count
	end

	# Returns the number of solved problems in a topic
	def topic_problems_solved(topic_name)
		count = SolvedProblem.select("ps.problem_id").
											where("ps.user_id = #{self.id}").
												joins("as ps inner join problem_categories as pc on ps.problem_id = pc.problem_id").
												joins("inner join subtopics as st on pc.subtopic_id = st.id AND st.name = #{ActiveRecord::Base.connection.quote(ActiveRecord::Base.connection.quote_string(topic_name))}").count



											#joins("as ps inner join subtopics as st on ps.problem_id = st.problem_id").where("st.name = #{ActiveRecord::Base.connection.quote(ActiveRecord::Base.connection.quote_string(topic_name))}").count
		return count
	end

	def self.filter_ranks(branches, users, leaderboard, user = nil)
		users_ids = ""
		if !users.nil?
			if users.include? "friends" and !users.include?("all") and !user.nil?
				users_ids = "SELECT relationships.followed_id AS id FROM relationships WHERE relationships.follower_id = #{user.id} UNION SELECT users.id AS id FROM users WHERE users.id = #{user.id} "

			end
		end
		
		problem_ids = []
		if !branches.nil?
			branches.each_with_index do |b, index|
				problem_ids << "SELECT p.id FROM problems as p INNER JOIN problem_categories as pc on pc.problem_id = p.id INNER JOIN subtopics as st on st.id = pc.subtopic_id AND st.branch_id = #{b} " 
			end
		end
		

		query = ""
		if leaderboard == "score" || leaderboard == "kudos"
			if leaderboard == "score"
				query = "SELECT SUM(Problems.points) AS score, Solved_Problems.user_id AS id FROM problems INNER JOIN solved_problems ON Problems.id = Solved_Problems.problem_id "

				if !users_ids.empty?
					query += "AND solved_problems.user_id IN (#{users_ids}) "
				end

				problem_ids.each_with_index do |ids, index|
					if index != problem_ids.length - 1
						if index == 0
							query += "AND (solved_problems.problem_id IN (#{ids}) "
						else
							query += "OR solved_problems.problem_id IN (#{ids}) "
						end
					else
						if index == 0
							query += "AND (solved_problems.problem_id IN (#{ids})) "
						else
							query += "OR solved_problems.problem_id IN (#{ids})) "
						end
					end
				end
				query += "Group BY solved_problems.user_id "
=begin
				if users_ids.empty?
					query += "UNION SELECT 0 AS score, users.id AS id FROM users WHERE users.id NOT IN (#{query}) "
				end
=end
			elsif leaderboard == "kudos"
				query1 = "SELECT users.id AS id, SUM(posts.cached_votes_score) AS p_score FROM users "

				query1 += "INNER JOIN posts ON users.id = posts.user_id "
				if !users_ids.empty?
					query1 += "AND users.id IN (#{users_ids}) "
				end
 
				query1 += "INNER JOIN topics ON topics.id = posts.topic_id
							INNER JOIN problems ON problems.id = topics.problem_id "
				problem_ids.each_with_index do |ids, index|
					if index != problem_ids.length - 1
						if index == 0
							query1 += "AND (problems.id IN (#{ids}) "
						else
							query1 += "OR problems.id IN (#{ids}) "
						end
					else
						if index == 0
							query1 += "AND (problems.id IN (#{ids})) "
						else
							query1 += "OR problems.id IN (#{ids})) "
						end
					end
				end
				query1 += "GROUP BY users.id "


				query2 = "SELECT users.id AS id, SUM(comments.cached_votes_score) AS c_score FROM users "

				query2 += "INNER JOIN comments ON users.id = comments.user_id "
				if !users_ids.empty?
					query2 += "AND users.id IN (#{users_ids}) "
				end

				query2 +=	"INNER JOIN posts ON comments.post_id = posts.id
							INNER JOIN topics ON topics.id = posts.topic_id
							INNER JOIN problems ON problems.id = topics.problem_id "

				problem_ids.each_with_index do |ids, index|
					if index != problem_ids.length - 1
						if index == 0
							query2 += "AND (problems.id IN (#{ids}) "
						else
							query2 += "OR problems.id IN (#{ids}) "
						end
					else
						if index == 0
							query2 += "AND (problems.id IN (#{ids})) "
						else
							query2 += "OR problems.id IN (#{ids})) "
						end
					end
				end
				query2 += "GROUP BY users.id "

				query = "SELECT table1.id AS id, coalesce(table1.p_score + table2.c_score, table1.p_score, table2.c_score) AS score FROM (#{query1}) AS table1 LEFT OUTER JOIN  (#{query2}) AS table2 ON table1.id = table2.id "
							query += "UNION 
												SELECT table2.id AS id, coalesce(table1.p_score + table2.c_score, table1.p_score, table2.c_score) AS score FROM (#{query2}) AS table2 LEFT OUTER JOIN (#{query1}) AS table1 ON table1.id = table2.id "
			end
		elsif leaderboard == "problems-solved"
			query = "SELECT COUNT(solved_problems.problem_id) AS score, solved_problems.user_id AS id FROM solved_problems WHERE "
			problem_ids.each_with_index do |ids, index|
				if index != problem_ids.length - 1
					if index == 0
						query += "(solved_problems.problem_id IN (#{ids}) "
					else
						query += "OR solved_problems.problem_id IN (#{ids}) "
					end
				else
					if index == 0
						query += "(solved_problems.problem_id IN (#{ids})) "
					else
						query += "OR solved_problems.problem_id IN (#{ids})) "
					end
				end
			end

			
			if !users_ids.empty?
				query += "AND solved_problems.user_id IN (#{users_ids}) "
			end

			query += "GROUP BY solved_problems.user_id "

		end
		query += "ORDER BY score DESC"

		if !Rails.env.production?
			ranking = ActiveRecord::Base.connection.execute(query)
		else
			ranking = ActiveRecord::Base.connection.exec_query(query).entries
		end
		return ranking
	end

	def unread_messages? 
		conversations = Conversation.where("sender_id = #{self.id} OR recipient_id = #{self.id}")

		conversations.each do |conversation|
			if conversation.read?(self) == "not-read"
				return true
			end
		end
		return false
	end

	def unread_notifications?
		self.notifications.each do |n|
			if n.read == false
				return true
			end
		end
		return false
	end

	private
	
		# Validates the size of an uploaded image
		def profile_image_size
			if self.profile_image.size > 5.megabytes
				errors.add(:profile_image, "should be less than 5MB")
			end
		end
		

	scope :all_except, -> (user) do 
		where.not(id: user) && where.not(id: user.friends.select(:id))
	end

end
