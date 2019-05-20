# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def index
    @q = current_user.activities.ransack(params[:q])
    @activities = @q.result(distinct: true).order_newest.paginate(page: params[:page])
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def sync_data
    StravaApi.sync_data(current_user)
    flash[:notice] = 'Sync successfully'

    redirect_to activities_path
  end
end
