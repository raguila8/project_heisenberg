require "rails_helper"

RSpec.describe Notification do
  let(:follow_notification) { FactoryBot.build_stubbed(:follow_notification, 
             post: post, user: post.user) }
  let(:post) { FactoryBot.build_stubbed(:post) }

  it "should have a user" do
    expect(follow_notification.valid?).to be_truthy
    follow_notification.user = nil
    expect(follow_notification.valid?).not_to be_truthy
  end

  it "should have a notified_by" do
    follow_notification.notified_by = nil
    expect(follow_notification.valid?).not_to be_truthy
  end

  describe "notification_type" do
    it "should be present" do
      follow_notification.notification_type = "follower"
      expect(follow_notification.valid?).to be_truthy
      follow_notification.notification_type = nil
      expect(follow_notification.valid?).not_to be_truthy
      follow_notification.notification_type = ""
      expect(follow_notification.valid?).not_to be_truthy
    end

    it "should be either 'comment' or 'follower'" do
      valid_notification_types = ["comment", "follower"]
      invalid_notification_types = ["comments", "followers", "post", "news"]

      valid_notification_types.each do |w|
        follow_notification.notification_type = w
        expect(follow_notification.valid?).to be_truthy, 
                  "#{valid_notification_types.inspect} should be valid"

      end

      invalid_notification_types.each do |w|
        follow_notification.notification_type = w
        expect(follow_notification.valid?).not_to be_truthy, 
                  "#{invalid_notification_types.inspect} should be invalid"
      end

    end
  end
end
