require 'rails_helper'

RSpec.describe 'conversation routing', :aggregate_failures, type: :routing do
  it "routes conversations" do
    expect(post: "/conversations").to route_to(
      controller: "conversations", action: "create")

    expect(get: "/conversations/1").to route_to(
      controller: "conversations", action: "show", id: "1")
  end
end
