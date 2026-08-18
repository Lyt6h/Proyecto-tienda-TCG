class FavoritesController < ApplicationController
  # Filtro de seguridad: solo usuarios logueados pueden tener favoritos

  def index
    # Traemos los favoritos del usuario que inició sesión
    @favorites = Current.user.favorites.includes(:card)
  end

  def create
    @card = Card.find(params[:card_id])

    # Creamos el favorito si no existe ya
    unless Current.user.favorites.exists?(card_id: @card.id)
      Current.user.favorites.create(card_id: @card.id)
      flash[:notice] = "¡#{@card.name} agregada a tu Wishlist! ✨"
    else
      flash[:alert] = "Esa carta ya está en tu lista."
    end

    redirect_back fallback_location: root_path
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy

    # Redireccionamos a donde el usuario estaba (la galería o la wishlist)
    redirect_back fallback_location: root_path, notice: "Removida de la Wishlist ✨"
  end
end
