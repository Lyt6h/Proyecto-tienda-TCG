require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "3. debería cargar la vista de la Wishlist" do
    user = User.create!(username: "wishlist1", email_address: "wish@test.com", password: "password123")
    sign_in_as(user)

    get favorites_path
    assert_response :success
  end

  test "4. debería aumentar la cantidad de favoritos al agregar una carta" do
    user = User.create!(username: "fan1", email_address: "fan@test.com", password: "password123")
    sign_in_as(user)

    card = Card.create!(name: "Mewtwo")

    assert_difference("Favorite.count", 1) do
      post favorites_path, params: { card_id: card.id }
    end
  end

  test "5. no debería dejar agregar favoritos si no hay sesión" do
    card = Card.create!(name: "Pikachu")

    assert_no_difference("Favorite.count") do
      post favorites_path, params: { card_id: card.id }
    end
  end
end
