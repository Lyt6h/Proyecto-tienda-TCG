require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = User.first
    # Usamos el helper de sesión si existe, o simulamos el login
    post session_path, params: { login: user.email_address, password: "secret" }

    get root_url
    assert_response :success
  end
end
