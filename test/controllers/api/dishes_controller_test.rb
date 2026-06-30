require "test_helper"

class Api::DishesControllerTest < ActionDispatch::IntegrationTest
  test "should get next" do
    get api_dishes_next_url
    assert_response :success
  end
end
