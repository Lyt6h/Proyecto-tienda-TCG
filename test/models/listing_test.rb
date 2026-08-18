require "test_helper"

class ListingTest < ActiveSupport::TestCase
  def setup
    @seller = User.create!(
      username: "user",
      email_address: "user@test.com",
      password: "password123"
    )
    @card = Card.create!(name: "Pikachu", energy_type: "Lightning", rarity: "Common", release_year: 1999)
  end

  test "listing valido con datos correctos" do
    listing = Listing.new(card: @card, seller: @seller, price: 5000, stock: 2, condition: "Mint", status: "active")
    result = listing.save
    assert result, "Listing debería ser valido con datos correctos"
  end

  test "listing invalido con precio negativo" do
    listing = Listing.new(card: @card, seller: @seller, price: -100, stock: 1, condition: "Mint", status: "active")
    result = listing.save
    assert_not result, "Listing no deberia ser valido con precio negativo"
  end

  test "listing invalido sin precio" do
    listing = Listing.new(card: @card, seller: @seller, stock: 1, condition: "Mint", status: "active")
    result = listing.save
    assert_not result, "Listing no deberia ser valido sin precio"
  end

  test "listing invalido con precio no permitido" do
    listing = Listing.new(card: @card, seller: @seller, price: "si", stock: 1, condition: "Mint", status: "active")
    result = listing.save
    assert_not result, "Listing no deberia ser valido con precio no permitido"
  end

  test "listing invalido con stock negativo" do
    listing = Listing.new(card: @card, seller: @seller, stock: -1, price: 5000, condition: "Mint", status: "active")
    result = listing.save
    assert_not result, "Listing no deberia ser valido con stock negativo"
  end

  test "listing invalido con stock no permitido" do
    listing = Listing.new(card: @card, seller: @seller, stock: "si", price: 5000, condition: "Mint", status: "active")
    result = listing.save
    assert_not result, "Listing no deberia ser valido con stock no permitido"
  end

  test "listing invalido con status no permitido" do
    listing = Listing.new(card: @card, seller: @seller, price: 1000, stock: 1, condition: "Mint", status: "inexistente")
    result = listing.save
    assert_not result, "Listing no deberia ser valido con status no permitido"
  end
end
