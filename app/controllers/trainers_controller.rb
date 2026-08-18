class TrainersController < ApplicationController
  allow_unauthenticated_access only: :show
  before_action :resume_session_if_available, only: [ :show ]

  def show
    @trainer = User.find(params[:id])
    @listings = @trainer.listings.where("stock > 0").includes(:card)
    @seller_reviews = Review
                      .joins(order_item: :order)
                      .where(orders: { seller_id: @trainer.id })
                      .includes(order_item: { order: :client })
    @average_rating = @seller_reviews.average(:seller_rating).to_f.round(1)
  end
end
