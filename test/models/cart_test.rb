require "test_helper"

class CartTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(username: "comprador", email_address: "comprador@test.com", password: "password123")
    @cart = Cart.create!(user: @user)
    @seller = User.create!(username: "vendedor", email_address: "vendedor@test.com", password: "password123")
    @card = Card.create!(name: "Mewtwo", energy_type: "Psychic", rarity: "Rare Holo", release_year: 1999)
    @listing = Listing.create!(card: @card, seller: @seller, price: 9999, stock: 3, condition: "Mint", status: "active")
  end

  test "total_quantity retorna la suma de cantidades del carrito" do
    CartItem.create!(cart: @cart, listing: @listing, quantity: 3)
    assert_equal 3, @cart.total_quantity
  end

  test "total_quantity retorna 0 cuando el carrito esta vacio" do
    assert_equal 0, @cart.total_quantity
  end
end
