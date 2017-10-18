require 'test_helper'

class UpvotesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get upvotes_new_url
    assert_response :success
  end

end
