require 'rails_helper'

RSpec.describe 'session routing', :aggregate_failures, type: :routing do
  it "routes sessions" do
    expect(post: "/sign_in").to route_to(
      controller: "sessions", action: "create")

    expect(get: "/sign_in").to route_to(
      controller: "sessions", action: "new")

    expect(delete: "/sign_out").to route_to(
      controller: "sessions", action: "destroy")
  end
end
