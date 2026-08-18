class ApiCardsController < ApplicationController
  before_action :require_authentication
  before_action :require_complete_profile

  def search
    if params[:query].present?
      begin
        # Usamos comillas para que nombres con espacios (ej: "Mega Latias") no rompan la consulta
        @api_cards = Pokemon::Card.where(q: "name:\"#{params[:query]}\"").first(15)
      rescue
        flash.now[:alert] = "La API de Pokémon tardó demasiado en responder o hubo un error. Intenta de nuevo."
        @api_cards = []
      end
    else
      @api_cards = []
    end
  end

  def create_listing
    # Buscamos o creamos la carta en nuestra base local
    @card = Card.find_or_create_by!(name: params[:name], card_number: params[:card_number]) do |card|
      card.expansion = params[:expansion]
      card.rarity = params[:rarity]
      card.energy_type = params[:energy_type]
      card.release_year = params[:release_year].to_i
      card.image_url = params[:image_url]
    end

    # Creamos la publicación para el vendedor actual
    @listing = Current.user.listings.new(
      card: @card,
      price: params[:price],
      stock: params[:stock],
      condition: params[:condition],
      status: "active"
    )

    if @listing.save
      redirect_to my_products_products_path, notice: "¡Carta publicada exitosamente!"
    else
      redirect_to api_cards_search_path(query: params[:name]),
                  alert: "Error al publicar la carta: #{@listing.errors.full_messages.to_sentence}"
    end
  end
end
