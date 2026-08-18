class PurchasesController < ApplicationController
  def index
    @orders = Order.where(client_id: Current.user.id)
                   .includes(order_items: { listing: :card })
                   .order(created_at: :desc)

    if params[:status].present?
      @orders = @orders.where(status: params[:status])
    end

    # Mark all unseen notifications as seen
    @orders.where(buyer_notification_seen: false).update_all(buyer_notification_seen: true)
  end
end
