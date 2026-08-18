require "test_helper"

class NotificationsTest < ActionDispatch::IntegrationTest
  setup do
    @seller = User.create!(username: "seller", email_address: "seller@test.com", password: "password123")
    @buyer = User.create!(username: "buyer", email_address: "buyer@test.com", password: "password123")

    @card = Card.create!(name: "Pikachu", energy_type: "Electric", rarity: "Rare", expansion: "Base",
                         release_year: 1999)
    @listing = Listing.create!(seller: @seller, card: @card, price: 100, stock: 10, condition: "M", status: "active")
  end

  test "seller sees notification badge for pending approval sales" do
    Order.create!(client: @buyer, seller: @seller, status: "pending_approval", subtotal: 100, service_fee: 10,
                  total_price: 110)

    sign_in_as(@seller)
    get products_path

    assert_select "span", text: "1" # Sales badge
  end

  test "buyer sees notification badge when order is accepted" do
    Order.create!(client: @buyer, seller: @seller, status: "accepted", buyer_notification_seen: false,
                  subtotal: 100, service_fee: 10, total_price: 110)

    sign_in_as(@buyer)
    get products_path

    assert_select "span", text: "!" # Purchases badge
  end

  test "buyer notification badge disappears after visiting purchases page" do
    order = Order.create!(client: @buyer, seller: @seller, status: "accepted", buyer_notification_seen: false,
                          subtotal: 100, service_fee: 10, total_price: 110)

    sign_in_as(@buyer)
    get products_path
    assert_select "span", text: "!"

    get purchases_path
    assert_response :success

    order.reload
    assert order.buyer_notification_seen

    get products_path
    assert_select "span", text: "!", count: 0
  end
end
