FactoryBot.define do
  factory :post do
    content "This is a sample post"
    topic
    user
  end

  factory :other_post, class: Post do
    content "Ths is another sample post"
    topic
    association :user, factory: :other_user
  end
end
