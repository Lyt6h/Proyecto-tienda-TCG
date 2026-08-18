require "test_helper"

class SalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller = User.create!(username: "vendedor1", email_address: "seller@test.com", password: "password123")
    @buyer = User.create!(username: "comprador1", email_address: "buyer@test.com", password: "password123")
    @card = Card.create!(name: "Pikachu", card_number: "001", expansion: "Base")
    @listing = Listing.create!(seller: @seller, card: @card, price: 100, stock: 5)
    @order = Order.create!(seller: @seller, client: @buyer, status: "pending_approval", subtotal: 100, total_price: 110)
    @item = OrderItem.create!(order: @order, listing: @listing, quantity: 1, unit_price: 100)
    sign_in_as(@seller)
  end

  test "should get index" do
    get sales_path
    assert_response :success
    assert_select "h1", text: I18n.t("sales.title")
  end

  test "should accept sale" do
    patch accept_sale_path(id: @order.id)
    assert_redirected_to sales_path
    @order.reload
    assert_equal "accepted", @order.status
    assert_not @order.buyer_notification_seen
    assert_equal I18n.t("sales.accepted_notice"), flash[:notice]
  end

  test "should reject sale and return stock" do
    initial_stock = @listing.stock
    patch reject_sale_path(id: @order.id)
    assert_redirected_to sales_path
    @order.reload
    assert_equal "rejected", @order.status
    @listing.reload
    assert_equal initial_stock + 1, @listing.stock
    assert_equal "active", @listing.status
    assert_equal I18n.t("sales.rejected_notice"), flash[:notice]
  end

  test "should return stock and set listing to active if it was sold_out" do
    @listing.update!(stock: 0, status: "sold_out")
    patch reject_sale_path(id: @order.id)
    @listing.reload
    assert_equal 1, @listing.stock
    assert_equal "active", @listing.status
  end

  test "should not accept or reject another seller's order" do
    @other_seller = User.create!(username: "vendedor2", email_address: "seller2@test.com", password: "password123")
    @other_order = Order.create!(seller: @other_seller, client: @buyer, status: "pending_approval", subtotal: 100,
                                 total_price: 110)

    # Tentativa de aceptar orden ajena
    patch accept_sale_path(id: @other_order.id)
    assert_redirected_to sales_path
    assert_equal I18n.t("sales.error_accepting"), flash[:alert]

    # Tentativa de rechazar orden ajena
    patch reject_sale_path(id: @other_order.id)
    assert_redirected_to sales_path
    assert_equal I18n.t("sales.error_rejecting"), flash[:alert]

    @other_order.reload
    assert_equal "pending_approval", @other_order.status
  end
end
