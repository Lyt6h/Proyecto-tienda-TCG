require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    post session_path, params: { login: @user.email_address, password: "secret" }

    assert_redirected_to products_path
    assert cookies[:session_id].present?
  end

  test "create with invalid credentials" do
    post session_path, params: { login: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert cookies[:session_id].blank?
  end

  test "destroy" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to products_path
    assert cookies[:session_id].blank?
  end
end
