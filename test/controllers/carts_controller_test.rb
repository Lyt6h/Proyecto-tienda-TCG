require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "1. debería poder ver su carrito de compras" do
    user = User.create!(username: "cartuser1", email_address: "cart@test.com", password: "password123")
    sign_in_as(user)

    Cart.create!(user_id: user.id)

    get cart_path
    assert_response :success
  end

  test "2. debería poder agregar una publicación al carrito" do
    comprador = User.create!(username: "cliente7", email_address: "cliente7@test.com", password: "password123")
    sign_in_as(comprador)
    Cart.create!(user_id: comprador.id)

    vendedor = User.create!(username: "tienda7", email_address: "tienda7@test.com", password: "password123")
    carta = Card.create!(name: "Blastoise")
    listing = Listing.create!(card_id: carta.id, seller_id: vendedor.id, price: 5000, stock: 10)

    # verificamos que al hacer la petición, el contador de CartItem suba en +1
    assert_difference("CartItem.count", 1) do
      post add_item_cart_path(listing_id: listing.id), params: { quantity: 1 }
    end
  end

  test "no debería agregar item si no hay stock" do
    user = users(:one)
    sign_in_as(user)

    listing = listings(:one)
    listing.update!(stock: 0)

    assert_no_difference("CartItem.count") do
      post add_item_cart_path(listing_id: listing.id)
    end
    assert_redirected_to products_path
    assert_not_nil flash[:alert]
  end

  test "debería poder eliminar un item del carrito" do
    user = users(:one)
    sign_in_as(user)
    cart = user.cart || user.create_cart
    listing = listings(:one)
    cart.cart_items.create!(listing: listing, quantity: 1)

    assert_difference("CartItem.count", -1) do
      delete remove_item_cart_path(listing_id: listing.id)
    end
    assert_redirected_to cart_path
  end

  test "debería completar el checkout exitosamente, reservar stock y calcular comisiones" do
    user = users(:one)
    users(:two)
    sign_in_as(user)
    cart = user.cart || user.create_cart
    listing = listings(:two) # listing two belongs to seller two
    initial_stock = listing.stock
    price = listing.price
    cart.cart_items.create!(listing: listing, quantity: 1)

    assert_difference("Order.count", 1) do
      post checkout_cart_path
    end

    assert_redirected_to products_path
    assert_equal 0, cart.cart_items.count
    assert_equal initial_stock - 1, listing.reload.stock

    order = Order.last
    assert_equal "pending_approval", order.status
    assert_equal price, order.subtotal
    assert_equal price * 0.03, order.service_fee
    assert_equal price * 1.03, order.total_price
  end
end
