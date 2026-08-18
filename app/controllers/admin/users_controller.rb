class Admin::UsersController < Admin::ApplicationController
  def show
    @user = User.includes(listings: :card).find(params[:id])
    # Contamos las órdenes donde este usuario es el vendedor y el estado es 'completed'
    @total_sales = @user.seller_orders.where(status: "completed").count

    # Cargar todas las reseñas que ha recibido este usuario como vendedor
    @seller_reviews = Review
                      .joins(order_item: :order)
                      .where(orders: { seller_id: @user.id })
                      .includes(order_item: { order: :client })
  end

  def ban
    @user = User.find(params[:id])
    @user.update(banned_at: Time.current)
    redirect_to admin_dashboard_path, notice: t("admin.dashboard.flash.banned")
  end

  def unban
    @user = User.find(params[:id])
    @user.update(banned_at: nil)
    redirect_to admin_dashboard_path, notice: t("admin.dashboard.flash.unbanned")
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_dashboard_path, notice: t("admin.dashboard.flash.destroyed")
  end

  def destroy_review
    @user = User.find(params[:id])
    review = Review
             .joins(order_item: :order)
             .where(orders: { client_id: @user.id })
             .find(params[:review_id])
    review.destroy
    redirect_to admin_user_path(@user), notice: t("admin.users.show.reviews.deleted")
  end
end
