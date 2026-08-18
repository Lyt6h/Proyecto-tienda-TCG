require "test_helper"

class TrainersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get show" do
    get trainer_url(id: @user.id)
    assert_response :success
  end
end
