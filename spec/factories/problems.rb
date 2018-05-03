FactoryBot.define do
  factory :problem do
    question "What is 1 + 1?"
    answer 2
    difficulty 1
    points 20
    submissions 5
    title "Addition"
    solved_by 2
  end
end
