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

branches = ["Classical Mechanics", "Electromagnetism", "Thermodynamics", "Quantum Mechanics", "Special Relativity"]
subtopic1 = ["Energy", "Oscillations", "kinematics", "Lagrange's Equation", "Momentum and Angular Momentum"]
subtopic2 = ["Charges and Fields", "The Electric Potential", "Electric Fields Around Conductors", "Electric Currents", "Magnetic Fields"]
subtopic3 = ["Probability Theory", "Statistical Mechanics", "Heat and Work", "Statistical Thermodynamics", "Classical Thermodynamics"]
subtopic4 = ["The Wave Function", "Time Independent Schrodinger Equation", "Identical Particles", "The Variational Principle", "Scattering"]
subtopic5 = ["Time Dilation", "Length Contraction", "The Lorentz Transformation", "Collisions", "Four Vectors"]
subtopics = [subtopic1, subtopic2, subtopic3, subtopic4, subtopic5]

5.times do |n|
	branch = Branch.new
	branch.name = branches[n]
	branch.save
	subtopics[n].each do |topic|
		subtopic = Subtopic.new
		subtopic.branch_id = branch.id
		subtopic.name = topic
		subtopic.save
	end
end



19.times do |n|
  username  = Faker::Internet.user_name(5..18)
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  user = User.create(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)

	con = Conversation.create!(sender_id: user.id, recipient_id: User.first.id)
	body = Faker::Lorem.paragraph
	Message.create!(body: body, user_id: user.id, conversation_id: con.id)

end

20.times do |n|
	problem = Problem.new
	num1 = Faker::Number.between(1,2)
	num2 = Faker::Number.between(1,2)
	problem.question = "What is #{num1} + #{num2}?"
	problem.answer = num1 + num2
	problem.difficulty = Faker::Number.between(1,3)
	if problem.difficulty == 1
		problem.points = 20
	elsif problem.difficulty == 2
		problem.points = 40
	else
		problem.points = 80
	end
	problem.title = "Addition#{n}"
	problem.solved_by = 0
	category = ProblemCategory.new
	category.subtopic_id = Random.new.rand(1..25)
	
	while !problem.save
		puts problem
		problem = Problem.new
		num1 = Faker::Number.between(1,2)
		num2 = Faker::Number.between(1,2)
		problem.question = "What is #{num1} + #{num2}?"
		problem.answer = num1 + num2
		problem.difficulty = Faker::Number.between(1,3)
		problem.title = "Addition#{n}"
		problem.solved_by = 0
	end
	category.problem_id = problem.id
	category.save
end

20.times do |n|
	user = User.find(n + 1)
	answer = Faker::Number.between(1,4)
	name = "Problem #{n + 1}"
	topic = Topic.create(name: name, forum_id: 1, problem_id: n + 1)

	20.times do |i|
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
			user.save
		end
		problem.submissions += 1
		problem.save
	end
end

20.times do |i|
	
end

