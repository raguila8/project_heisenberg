# This file should contain all the record creation needed to seed the database with its default values.
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

99.times do |n|
  username  = Faker::Internet.user_name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)
end

100.times do |n|
	problem = Problem.new
	num1 = Faker::Number.between(1,5)
	num2 = Faker::Number.between(1,5)
	problem.question = "What is #{num1} + #{num2}?"
	problem.answer = num1 + num2
	problem.subject = "Basic Math"
	problem.difficulty = Faker::Number.between(1,3)
	problem.title = "Addition"
	problem.solved_by = 0
	problem.save
end

100.times do |n|
	user = User.find(n + 1)
	answer = Faker::Number.between(1,10)
	100.times do |i|
		problem = Problem.find(i + 1)
		if problem.answer == answer
			user.problems << problem
			user.solved += 1
			user.score += problem.difficulty * 20
			problem.solved_by += 1
			problem.save
			user.save
		end
	end
end


