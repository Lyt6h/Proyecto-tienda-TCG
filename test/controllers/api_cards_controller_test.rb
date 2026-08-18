require "test_helper"

class ApiCardsControllerTest < ActionDispatch::IntegrationTest
  test "should create listing and redirect on success" do
    user = users(:one)
    post session_path, params: { login: user.email_address, password: "secret" }

    assert_difference([ "Card.count", "Listing.count" ], 1) do
      post api_cards_create_listing_path, params: {
        name: "Unique Pikachu",
        card_number: "25",
        expansion: "Celebrations",
        rarity: "Rare",
        price: 100,
        stock: 1,
        condition: "near_mint",
        image_url: "http://example.com/pika.png"
      }
    end

    assert_redirected_to my_products_products_path
    assert_equal "¡Carta publicada exitosamente!", flash[:notice]
  end

  test "should redirect to search on listing creation failure" do
    user = users(:one)
    post session_path, params: { login: user.email_address, password: "secret" }

    assert_no_difference("Listing.count") do
      post api_cards_create_listing_path, params: {
        name: "Charmander",
        price: nil
      }
    end

    assert_redirected_to api_cards_search_path(query: "Charmander")
    assert_match(/Error al publicar la carta/, flash[:alert])
  end
end
