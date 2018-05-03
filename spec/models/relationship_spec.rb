require "rails_helper"

RSpec.describe Relationship do
  let (:follower) { FactoryBot.build_stubbed(:user, username: "user1", 
                    email: "user1@example.com") }
  let (:followed) { FactoryBot.build_stubbed(:user, username: "user2", 
                    email: "user2@example.com") }
  let (:relationship) { Relationship.new(follower: follower, 
                        followed: followed) }

  it "should have a follower" do
    expect(relationship.valid?).to be_truthy
    relationship.follower = nil
    expect(relationship.valid?).not_to be_truthy
  end

  it "should have a followed" do
    relationship.followed = nil
    expect(relationship.valid?).not_to be_truthy
  end

  it "should not have the same follower and followed" do
    relationship.followed = follower
    expect(relationship.valid?).not_to be_truthy
  end
end
