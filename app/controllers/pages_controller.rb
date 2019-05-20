# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    if params[:code].present?
      current_user.update!(strava_code: params[:code], team: 'BNR')
      StravaApi.exchange_token(current_user)
      flash[:notice] = 'Connect successfully'
      redirect_to activities_path
    elsif current_user.strava_code.blank?
      flash[:notice] = 'Please connect strava'
    end
  end
end
