require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "debería ver la lista de productos (index)" do
    get products_path
    assert_response :success
  end

  test "debería filtrar productos por nombre" do
    carta = Card.create!(name: "Mewtwo", expansion: "Base", rarity: "Rare", energy_type: "Psychic", release_year: 1999)
    Listing.create!(card: carta, seller: users(:two), price: 1000, stock: 5, status: "active", condition: "near_mint")

    get products_path, params: { name: "Mewtwo" }
    assert_response :success
    assert_match(/Mewtwo/i, response.body)
  end

  test "debería crear un nuevo producto (listing)" do
    carta = cards(:one)

    assert_difference("Listing.count", 1) do
      post products_path, params: {
        product: {
          card_id: carta.id,
          price: 1500,
          stock: 10,
          condition: "mint"
        }
      }
    end
    assert_redirected_to my_products_products_path
    assert_equal I18n.t("products.notices.created"), flash[:notice]
  end

  test "debería poder editar un producto propio" do
    producto = Listing.create!(card: cards(:one), seller: @user, price: 1000, stock: 5, status: "active",
                               condition: "near_mint")

    patch product_path(id: producto.id), params: {
      product: { price: 2000 }
    }

    assert_redirected_to my_products_products_path
    assert_equal 2000, producto.reload.price
    assert_equal I18n.t("products.notices.updated"), flash[:notice]
  end
end
