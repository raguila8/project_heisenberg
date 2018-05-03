FactoryBot.define do
  factory :post do
    content "This is a sample post"
    topic
    user
  end
end
