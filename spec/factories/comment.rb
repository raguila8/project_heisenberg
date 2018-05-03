FactoryBot.define do
  factory :comment do
    content "This is a sample comment"
    post
    user
  end
end
