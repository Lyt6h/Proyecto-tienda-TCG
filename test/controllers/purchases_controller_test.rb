require "test_helper"

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test "1. debería cargar el historial de compras correctamente con usuario logueado" do
    user = User.create!(username: "comprador1", email_address: "compra@test.com", password: "password123")
    sign_in_as(user)

    get purchases_path
    assert_response :success
  end

  test "2. debería mostrar la página en inglés si se cambia el locale" do
    user = User.create!(username: "bilingue1", email_address: "eng@test.com", password: "password123")
    sign_in_as(user)

    get purchases_path(locale: :en)
    assert_response :success
    assert_select "h1", "My Purchases 📦"
  end
end
