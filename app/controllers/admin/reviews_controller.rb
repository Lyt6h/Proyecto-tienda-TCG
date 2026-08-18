class Admin::ReviewsController < Admin::ApplicationController
  def destroy
    @review = Review.find(params[:id])
    user_id = @review.order_item.order.seller_id
    @review.destroy
    redirect_to admin_user_path(user_id), notice: t("admin.reviews.destroyed")
  end
end
