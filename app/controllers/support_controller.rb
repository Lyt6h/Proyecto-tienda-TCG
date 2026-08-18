class SupportController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    if authenticated?
      @name = Current.user.full_name.presence || Current.user.username
      @email = Current.user.email_address
    end
  end

  def create
    @support_message = SupportMessage.new(support_message_params)

    if @support_message.save
      redirect_to root_path, notice: t("support.notices.success")
    else
      @name = @support_message.name
      @email = @support_message.email
      @message = @support_message.message
      flash.now[:alert] = t("support.notices.error")
      render :new, status: :unprocessable_entity
    end
  end

  private
    def support_message_params
      params.permit(:name, :email, :message)
    end
end
