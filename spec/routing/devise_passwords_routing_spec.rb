require 'rails_helper'

RSpec.describe 'devise/password routing', :aggregate_failures, type: :routing do
  it "routes devise/passwords" do
    expect(post: "/users/password").to route_to(
      controller: "devise/passwords", action: "create")

    expect(get: "/users/password/new").to route_to(
      controller: "devise/passwords", action: "new")

    expect(get: "/users/password/edit").to route_to(
      controller: "devise/passwords", action: "edit")

    expect(patch: "/users/password").to route_to(
      controller: "devise/passwords", action: "update")
  end
end
