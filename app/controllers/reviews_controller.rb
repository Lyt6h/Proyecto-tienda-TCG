class ReviewsController < ApplicationController
  before_action :set_order_item, except: [ :report ]

  def new
    @review = @order_item.build_review
  end

  def create
    @review = @order_item.build_review(review_params)

    if @review.save
      redirect_to purchases_path, notice: "¡Reseña guardada con éxito! 🌟"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def report
    @review = Review.find(params[:id])
    @review.update(reported: true)
    redirect_back fallback_location: root_path,
                  notice: t("products.notices.review_reported", default: "Reseña reportada para revisión.")
  end

  private

    def set_order_item
      @order_item = OrderItem.find(params[:order_item_id])
    end

  def review_params
    params.require(:review).permit(:item_rating, :seller_rating, :comment)
  end
end
