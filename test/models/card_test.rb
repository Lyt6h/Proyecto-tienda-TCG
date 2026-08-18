require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "card valida con nombre presente" do
    card = Card.new(name: "Charizard", energy_type: "Fire", rarity: "Rare Holo", release_year: 1999)
    result = card.save
    assert result, "Card deberia ser valida con nombre presente"
  end

  test "card invalida, sin nombre" do
    card = Card.new(energy_type: "Fire", rarity: "Rare Holo", release_year: 1999)
    result = card.save
    assert_not result, "Card no debería ser valida sin nombre"
  end
end
