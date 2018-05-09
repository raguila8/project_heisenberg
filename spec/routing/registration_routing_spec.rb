require 'rails_helper'

RSpec.describe 'registration routing', :aggregate_failures, type: :routing do
  it "routes registrations" do
    expect(post: "/user_registration").to route_to(
      controller: "registrations", action: "create")

    expect(get: "/sign_up").to route_to(
      controller: "registrations", action: "new")

    expect(get: "/change_password/1").to route_to(
      controller: "registrations", action: "edit", id: "1")

    expect(patch: "/change_password/1").to route_to(
      controller: "registrations", action: "update", id: "1")

    expect(delete: "/user_registration").to route_to(
      controller: "registrations", action: "destroy")

    expect(get: "/cancel_registration").to route_to(
      controller: "registrations", action: "cancel")
  end
end
