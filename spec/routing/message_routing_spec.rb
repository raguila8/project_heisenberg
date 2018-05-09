require 'rails_helper'

RSpec.describe 'message routing', :aggregate_failures, type: :routing do
  it "routes messages" do
    expect(get: "/messages").to route_to(
      controller: "messages", action: "index")

    expect(post: "/messages").to route_to(
      controller: "messages", action: "create")
  end
end
