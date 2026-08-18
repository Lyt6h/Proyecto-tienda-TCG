class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[edit update]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
 redirect_to new_password_path, alert: I18n.t("flash.passwords.rate_limit") }

  def new
  end

  def create
    if (user = User.find_by(email_address: params[:email_address]))
      Rails.logger.info "Usuario Encontrado! Generando token para: #{user.email_address}"
      begin
        PasswordsMailer.reset(user).deliver_now
      rescue StandardError => e
        Rails.logger.error "Error sending password reset email to #{user.email_address}: #{e.message}"
      end
    end

    redirect_to new_session_path, notice: t("flash.passwords.instructions_sent")
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      redirect_to new_session_path, notice: t("flash.passwords.reset_success")
    else
      redirect_to edit_password_path(token: params[:token]), alert: @user.errors.full_messages.to_sentence
    end
  end

  private

    def set_user_by_token
      @user = User.find_by_token_for!(:password_reset, params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: t("flash.passwords.invalid_or_expired")
    end
end
