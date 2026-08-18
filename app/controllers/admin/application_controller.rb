class Admin::ApplicationController < ApplicationController
  before_action :require_admin

  private

    def require_admin
      unless Current.session&.user&.is_admin?
        redirect_to root_path, alert: "Acceso denegado. No eres administrador."
      end
    end
end
