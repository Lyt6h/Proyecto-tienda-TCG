class CartsController < ApplicationController
  before_action :resume_session
  before_action :require_authentication

  def show
    @cart = Current.user.cart || Current.user.create_cart
  end

  def add_item
    @listing = Listing.find(params[:listing_id])

    if @listing.stock <= 0
      return redirect_to products_path, alert: t("flash.carts.out_of_stock", product_name: @listing.card.name)
    end

    @cart = Current.user.cart || Current.user.create_cart
    @cart_item = @cart.cart_items.find_or_initialize_by(listing: @listing)
    new_quantity = (@cart_item.quantity || 0) + 1

    if new_quantity > @listing.stock
      return redirect_to products_path, alert: t("flash.carts.out_of_stock", product_name: @listing.card.name)
    end

    @cart_item.quantity = new_quantity

    if @cart_item.save
      respond_to do |format|
        format.turbo_stream do
          badge_style = "position: absolute; top: -10px; right: -10px; background: #E3350D; color: white; " \
                        "border: 2px solid black; border-radius: 50%; padding: 2px 8px; " \
                        "font-family: 'Press Start 2P', cursive; font-size: 10px;"
          render turbo_stream: turbo_stream.replace(
            "cart-badge",
            "<span id='cart-badge' class='cart-badge' style='#{badge_style}'>#{@cart.total_quantity}</span>".html_safe
          )
        end
        format.html { redirect_to products_path, notice: t("flash.carts.added", product_name: @listing.card.name) }
      end
    else
      redirect_to products_path, alert: t("flash.carts.add_error")
    end
  end

  def checkout
    @cart = Current.user.cart
    if @cart.nil? || @cart.cart_items.empty?
      return redirect_to products_path, alert: t("flash.carts.empty")
    end

    ActiveRecord::Base.transaction do
      # Agrupamos por seller_id para crear una orden por cada vendedor
      items_by_seller = @cart.cart_items.joins(:listing).group_by { |item| item.listing.seller_id }

      items_by_seller.each do |seller_id, items|
        subtotal = items.sum { |item| item.listing.price * item.quantity }
        service_fee = subtotal * 0.03
        total_price = subtotal + service_fee

        order = Order.create!(
          client: Current.user,
          seller_id: seller_id,
          status: "pending_approval",
          subtotal: subtotal,
          service_fee: service_fee,
          total_price: total_price
        )

        items.each do |item|
          order.order_items.create!(
            listing: item.listing,
            unit_price: item.listing.price,
            quantity: item.quantity
          )

          # RESERVA DE STOCK:
          new_stock = item.listing.stock - item.quantity
          if new_stock < 0
            raise "Insufficient stock for #{item.listing.card.name}"
          end
          item.listing.update!(stock: new_stock, status: (new_stock <= 0 ? "sold_out" : "active"))
        end
      end

      # Limpiamos el carrito tras la compra exitosa
      @cart.cart_items.destroy_all
    end

    flash[:checkout_success] = true

    redirect_to products_path, notice: t("flash.carts.checkout_success")
  rescue => e
    puts "CHECKOUT ERROR: #{e.message}"
    puts e.backtrace.join("\n")
    redirect_to cart_path, alert: t("flash.carts.checkout_error")
  end

  def remove_item
    @cart = Current.user.cart
    @cart_item = @cart.cart_items.find_by(listing_id: params[:listing_id])

    if @cart_item
      if @cart_item.quantity > 1
        @cart_item.update(quantity: @cart_item.quantity - 1)
        redirect_to cart_path, notice: t("flash.carts.decreased")
      else
        @cart_item.destroy
        redirect_to cart_path, notice: t("flash.carts.removed")
      end
    else
      redirect_to cart_path, alert: t("flash.carts.missing")
    end
  end
end
