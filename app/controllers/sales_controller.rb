class SalesController < ApplicationController
  def index
    @pending_sales = Current.user.seller_orders
                            .where(status: "pending_approval")
                            .includes(:client, order_items: { listing: :card })
                            .order(created_at: :desc)
    @completed_sales = Current.user.seller_orders
                              .where.not(status: "pending_approval")
                              .includes(:client, order_items: { listing: :card })
                              .order(created_at: :desc)
  end

  def accept
    @order = Current.user.seller_orders.where(status: "pending_approval").find(params[:id])
    if @order.update(status: "accepted", buyer_notification_seen: false)
      redirect_to sales_path, notice: t("sales.accepted_notice")
    else
      redirect_to sales_path, alert: t("sales.error_accepting")
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to sales_path, alert: t("sales.error_accepting")
  end

  def reject
    @order = Current.user.seller_orders.where(status: "pending_approval").find(params[:id])
    ActiveRecord::Base.transaction do
      @order.update!(status: "rejected", buyer_notification_seen: false)
      @order.order_items.each do |item|
        listing = item.listing
        listing.update!(stock: listing.stock + item.quantity)
        listing.update!(status: "active") if listing.status == "sold_out"
      end
    end
    redirect_to sales_path, notice: t("sales.rejected_notice")
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
    redirect_to sales_path, alert: t("sales.error_rejecting")
  end
end
