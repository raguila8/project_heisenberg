FactoryBot.define do
  factory :conversation do
    association :sender, factory: :user, username: "foobar1", 
                                         email: "foobar1@email.com"
    association :recipient, factory: :user, username: "foobar2",
                                            email: "foobar2@email.com"
  end
end
