#This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(username:  "raguila8",
             email: "rodrigoaguilar887@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
						 admin: true)
Forum.create(name: "Problems", description: "Problems Forum")
=begin

49.times do |n|
  username  = Faker::Internet.user_name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)
end

50.times do |n|
	problem = Problem.new
	num1 = Faker::Number.between(1,5)
	num2 = Faker::Number.between(1,5)
	problem.question = "What is #{num1} + #{num2}?"
	problem.answer = num1 + num2
	problem.subject = "Basic Math"
	problem.difficulty = Faker::Number.between(1,3)
	problem.title = "Addition"
	problem.solved_by = 0
	problem.number = n + 1
	problem.save
end

50.times do |n|
	user = User.find(n + 1)
	answer = Faker::Number.between(1,10)
	name = "Problem #{n + 1}"
	topic = Topic.create(name: name, forum_id: 1, problem_id: n + 1)

	50.times do |i|
		content = Faker::Lorem.paragraph
		Post.create(content: content, topic_id: topic.id, user_id: i + 1)
		problem = Problem.find(i + 1)
		if problem.answer == answer
			user.problems << problem
			user.solved += 1
			if problem.difficulty == 1
				user.score += 20
			elsif problem.difficulty == 2
				user.score += 40
			elsif problem.difficulty == 3
				user.score += 80
			end
			problem.solved_by += 1
			problem.save
			user.save
		end
	end
end
=end

