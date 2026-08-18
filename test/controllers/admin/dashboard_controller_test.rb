require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "debería denegar acceso a dashboard si no es admin" do
    user = users(:one)
    sign_in_as(user)

    get admin_dashboard_path
    assert_redirected_to root_path
    assert_equal "Acceso denegado. No eres administrador.", flash[:alert]
  end

  test "debería permitir acceso a dashboard si es admin" do
    admin = users(:one)
    admin.update!(is_admin: true)
    sign_in_as(admin)

    get admin_dashboard_path
    assert_response :success
  end

  test "debería mostrar el botón del libro contable en el dashboard si es admin" do
    admin = users(:one)
    admin.update!(is_admin: true)
    sign_in_as(admin)

    get admin_dashboard_path
    assert_response :success
    assert_select "a[href=?]", admin_financials_path, text: I18n.t("admin.financials.ledger_btn")
  end
end
