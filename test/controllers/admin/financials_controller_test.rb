require "test_helper"

class Admin::FinancialsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @admin = users(:one)
    @admin.update!(is_admin: true)
  end

  test "should deny access if not admin" do
    sign_in_as(@user)
    @user.update!(is_admin: false)
    get admin_financials_path
    assert_redirected_to root_path
    assert_equal "Acceso denegado. No eres administrador.", flash[:alert]
  end

  test "should allow access if admin" do
    sign_in_as(@admin)
    get admin_financials_path
    assert_response :success
  end
end
