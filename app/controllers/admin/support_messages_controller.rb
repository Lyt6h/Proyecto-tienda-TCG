class Admin::SupportMessagesController < Admin::ApplicationController
  def index
    @support_messages = SupportMessage.ordered
  end

  def update
    @support_message = SupportMessage.find(params[:id])
    if @support_message.update(resolved: params[:resolved])
      redirect_to admin_support_messages_path, notice: t("support.admin.notices.updated")
    else
      redirect_to admin_support_messages_path, alert: t("support.admin.notices.update_error")
    end
  end

  def destroy
    @support_message = SupportMessage.find(params[:id])
    @support_message.destroy
    redirect_to admin_support_messages_path, notice: t("support.admin.notices.deleted"), status: :see_other
  end
end
