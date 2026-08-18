class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
  end

  def create
    # Eliminamos rate_limit y nombres dinámicos para máxima estabilidad en producción
    login_input = params[:login]
    password = params[:password]

    user = User.find_by(email_address: login_input.to_s.downcase.strip) ||
           User.find_by(username: login_input.to_s.strip)

    if user&.authenticate(password)
      if user.banned?
        redirect_to new_session_path, alert: t("admin.dashboard.flash.banned", default: "Tu cuenta ha sido suspendida.")
      else
        start_new_session_for user
        if user.is_admin?
          redirect_to admin_dashboard_path
        else
          redirect_to products_path, notice: t("flash.sessions.welcome", default: "¡Bienvenido!")
        end
      end
    else
      redirect_to new_session_path, alert: t("flash.sessions.invalid_credentials", default: "Credenciales inválidas.")
    end
  end

  def destroy
    terminate_session
    redirect_to products_path, status: :see_other, flash: { show_logout_modal: true }
  end
end
