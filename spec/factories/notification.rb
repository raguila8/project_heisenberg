FactoryBot.define do
  factory :follow_notification, class: Notification do
    association :notified_by, factory: :user
    notification_type "follower"
  end
end
