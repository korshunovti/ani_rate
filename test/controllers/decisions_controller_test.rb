require "test_helper"

class DecisionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decisions_index_url
    assert_response :success
  end
end
