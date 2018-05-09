require 'rails_helper'

RSpec.describe 'user routing', :aggregate_failures, type: :routing do
  it "routes users" do
    expect(get: "/users/1").to route_to(
      controller: "users", action: "show", id: "1")

    expect(get: "/leaderboards").to route_to(
      controller: "users", action: "index")

    expect(get: "/leaderboard_filter").to route_to(
      controller: "users", action: "leaderboard_filter")

    expect(get: "/users/1/edit").to route_to(
      controller: "users", action: "edit", id: "1")

    expect(put: "/users/1").to route_to(
      controller: "users", action: "update", id: "1")

    expect(get: "/autocomplete").to route_to(
      controller: "users", action: "autocomplete")

    expect(get: "/recently_solved_problems").to route_to(
      controller: "users", action: "recently_solved_problems")

    expect(get: "/edit_profile/1").to route_to(
      controller: "users", action: "edit_profile", id: "1")

    expect(patch: "/update_profile_img").to route_to(
      controller: "users", action: "update_profile_image")
 
    expect(patch: "/edit_profile/1").to route_to(
      controller: "users", action: "update_profile", id: "1")

  end
end
