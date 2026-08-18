# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.

puts "Seeding records..."

# Create Official Store User if it doesn't exist
shop = User.find_or_create_by!(email_address: "tienda@pokemarket.com") do |u|
  u.username = "TiendaOficial"
  u.password = "password123"
  u.password_confirmation = "password123"
end

puts "Official Store user ready: #{shop.username}"

cards_data = [
  { name: "Charizard", card_number: "4/102", expansion: "Base Set", rarity: "Rare Holo", energy_type: "Fire", release_year: 1999, image_url: "https://images.pokemontcg.io/base1/4_hires.png" },
  { name: "Blastoise", card_number: "2/102", expansion: "Base Set", rarity: "Rare Holo", energy_type: "Water", release_year: 1999, image_url: "https://images.pokemontcg.io/base1/2_hires.png" },
  { name: "Venusaur", card_number: "15/102", expansion: "Base Set", rarity: "Rare Holo", energy_type: "Grass", release_year: 1999, image_url: "https://images.pokemontcg.io/base1/15_hires.png" },
  { name: "Pikachu", card_number: "58/102", expansion: "Base Set", rarity: "Common", energy_type: "Lightning", release_year: 1999, image_url: "https://images.pokemontcg.io/base1/58_hires.png" },
  { name: "Mewtwo", card_number: "10/102", expansion: "Base Set", rarity: "Rare Holo", energy_type: "Psychic", release_year: 1999, image_url: "https://images.pokemontcg.io/base1/10_hires.png" }
]

cards_data.each do |data|
  card = Card.find_or_create_by!(name: data[:name], card_number: data[:card_number]) do |c|
    c.expansion = data[:expansion]
    c.rarity = data[:rarity]
    c.energy_type = data[:energy_type]
    c.release_year = data[:release_year]
    c.image_url = data[:image_url]
  end

  # Create listing for the shop if it doesn't already have one for this card
  unless shop.listings.exists?(card_id: card.id)
    shop.listings.create!(
      card: card,
      price: rand(50..1000),
      stock: 5,
      condition: "Mint",
      status: "active"
    )
  end
end

# Create Admin User if it doesn't exist
User.find_or_create_by!(email_address: "admin@test.com") do |u|
  u.username = "admin"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.is_admin = true
end

# Create a sample seller for testing
User.find_or_create_by!(email_address: "vendedor@test.com") do |u|
  u.username = "AshKetchum"
  u.password = "password123"
  u.password_confirmation = "password123"
end

puts "Seed completed safely!"
