# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :sync_data!

  protected

  def sync_data!
    if current_user.present? && (current_user.strava_last_sync_at.blank? || current_user.strava_last_sync_at <= Time.current - 2.hours)
      StravaApi.sync_data(current_user)
    end
  end

  def configure_permitted_parameters
    added_attrs = %i[name email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
