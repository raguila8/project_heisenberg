require 'rails_helper'

RSpec.describe 'relationship routing', :aggregate_failures, type: :routing do
  it "routes relationships" do
    expect(post: "/follow").to route_to(
      controller: "relationships", action: "create")

    expect(get: "/unfollow").to route_to(
      controller: "relationships", action: "destroy")
  end
end
