class ProductsController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :resume_session_if_available, only: [ :index, :show ]
  before_action :require_complete_profile, only: [ :new, :create ]

  def index
    @direction = params[:direction] == "desc" ? "desc" : "asc"

    # 1. Filtro Base
    @products = Listing.joins(:card).where("listings.stock > 0").where(listings: { status: "active" })

    # 2. ELIMINAR LAS CARTAS DEL USUARIO (Ahora sí despertamos a Rails a tiempo)
    if authenticated?
      @products = @products.where.not(listings: { seller_id: Current.user.id })
    end

    # 3. Orden de precio
    @products = @products.order(price: @direction)

    # 4. Búsqueda por nombre
    if params[:name].present?
      @products = @products.where("LOWER(cards.name) LIKE ?", "%#{params[:name].downcase}%")
    end

    # 5. Filtros de catálogo
    @products = @products.where(cards: { release_year: params[:year] }) if params[:year].present?
    @products = @products.where(cards: { rarity: params[:rarity] }) if params[:rarity].present?
    @products = @products.where(cards: { energy_type: params[:energy_type] }) if params[:energy_type].present?
    @products = @products.where(listings: { condition: params[:condition] }) if params[:condition].present?
  end

  def show
    @product = Listing.includes(:card, :seller).find(params[:id])
    @card_reviews = Review
                    .joins(order_item: { order: :client })
                    .includes(order_item: { order: :client })
                    .joins(order_item: :listing)
                    .where(listings: { card_id: @product.card_id })
    @favorite = Current.user ? Current.user.favorites.find_by(card_id: @product.card_id) : nil
  end

  def new
    @product = Listing.new
    @cards = Card.all # Para que el usuario seleccione la carta
  end

  def create
    @product = Current.user.listings.build(product_params)
    if @product.save
      redirect_to my_products_products_path, notice: t("products.notices.created")
    else
      @cards = Card.all
      render :new, status: :unprocessable_entity
    end
  end

  def my_products
    @products = Current.user.listings.order(created_at: :desc)
  end

  def edit
    @product = Current.user.listings.find(params[:id])
    @cards = Card.all
  end

  def update
    @product = Current.user.listings.find(params[:id])
    if @product.update(product_params)
      redirect_to my_products_products_path, notice: t("products.notices.updated")
    else
      @cards = Card.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Current.user.listings.find(params[:id])
    @product.destroy
    redirect_to my_products_products_path, notice: t("products.notices.deleted"), status: :see_other
  end

  private

    def product_params
      params.require(:product).permit(:card_id, :price, :stock, :condition)
    end
end
