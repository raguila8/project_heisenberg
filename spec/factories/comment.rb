FactoryBot.define do
  factory :comment do
    content "This is a sample comment"
    post
    user
  end

  factory :other_comment, class: Comment do
    content "This is another comment"
    association :user, factory: :other_user
  end
end
