class Admin::ListingsController < Admin::ApplicationController
  def destroy
    @listing = Listing.find(params[:id])
    @user = @listing.seller
    quantity_to_remove = params[:quantity].to_i

    if quantity_to_remove > 0 && quantity_to_remove < @listing.stock
      @listing.update(stock: @listing.stock - quantity_to_remove)
      notice_message = t("admin.users.show.flash.stock_reduced", count: quantity_to_remove)
    else
      @listing.destroy
      notice_message = t("admin.users.show.flash.listing_deleted")
    end

    redirect_to admin_user_path(@user), notice: notice_message
  end
end
