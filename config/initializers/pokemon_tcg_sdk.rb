# config/initializers/pokemon_tcg_sdk.rb
Pokemon.configure do |config|
  config.api_key = ENV["POKEMON_TCG_API_KEY"]
end
