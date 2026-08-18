class ApplicationController < ActionController::Base
  include Authentication
  before_action :set_locale

  before_action :update_last_seen_at, if: -> { Current.session&.user }
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  stale_when_importmap_changes

  def default_url_options
    { locale: I18n.locale }
  end

  private

    def set_locale
      requested_locale = params[:locale]&.to_sym
      I18n.locale = I18n.available_locales.include?(requested_locale) ? requested_locale : I18n.default_locale
    end

    def update_last_seen_at
      if Current.user.last_seen_at.nil? || Current.user.last_seen_at < 5.minutes.ago
        Current.user.update(last_seen_at: Time.current)
      end
    end

    def require_complete_profile
      unless Current.user.profile_complete?
        flash[:show_incomplete_profile_modal] = true
        redirect_back(fallback_location: root_path)
      end
    end

    def resume_session_if_available
      Current.session ||= Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end
end
