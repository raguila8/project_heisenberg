require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get root_path
    assert_response :success
		assert_select "title", "About | Project Heisenberg"
  end

end
