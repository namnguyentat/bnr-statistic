# frozen_string_literal: true

class ChallengesController < ApplicationController
  def index
    @q = Challenge.ransack(params[:q])
    @challenges = @q.result(distinct: true).order_newest.paginate(page: params[:page])
  end

  def show
    @challenge = Challenge.find(params[:id])
  end

  def new
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.new(
      min_distance: 4000,
      min_pace: 8,
      min_trail_distance: 10_000,
      min_trail_pace: 30
    )
  end

  def edit
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.find(params[:id])
  end

  def create
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.new(challenge_params)

    if @challenge.save
      @challenge.user_ids = User.team_bnr.pluck(:id)
      flash[:notice] = 'Create successfully'
      redirect_to challenge_path(@challenge)
    else
      flash[:alert] = @challenge.errors.full_messages
      render :new
    end
  end

  def update
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.find(params[:id])

    if @challenge.update(challenge_params)
      @challenge.user_ids = User.team_bnr.pluck(:id)
      flash[:notice] = 'Update successfully'
      redirect_to challenge_path(@challenge)
    else
      flash[:alert] = @challenge.errors.full_messages
      render :edit
    end
  end

  def destroy
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.find(params[:id])
    @challenge.destroy
    flash[:notice] = 'Delete successfully'

    redirect_to challenges_path
  end

  def sync_data
    @challenge = Challenge.find(params[:id])
    @challenge.users.each do |user|
      StravaApi.sync_data(user)
      mapping = ChallengeUserMapping.find_by(user: user, challenge: @challenge)
      mapping.update!(
        total: user.total_activities_in_challenge(@challenge).map(&:distance).sum
      )
    end
    flash[:notice] = 'Sync successfully'

    redirect_to challenge_path(@challenge)
  end

  def sync_data_for_user
    @challenge = Challenge.find(params[:id])
    @user = User.find(params[:user_id])
    StravaApi.sync_data(@user)
    mapping = ChallengeUserMapping.find_by(user: @user, challenge: @challenge)
    mapping.update!(
      total: @user.total_activities_in_challenge(@challenge).map(&:distance).sum
    )

    flash[:notice] = 'Sync successfully'

    redirect_to challenge_path(@challenge)
  end

  def set_target
    @challenge = Challenge.find(params[:id])
    @user = User.find(params[:user_id])
    mapping = ChallengeUserMapping.find_by(user: @user, challenge: @challenge)
    mapping.update!(target: params[:challenge_target])

    flash[:notice] = 'Update successfully'

    redirect_to challenge_path(@challenge)
  end

  def join
    unless current_user.team_bnr?
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.find(params[:id])
    ChallengeUserMapping.find_or_create_by(user: current_user, challenge: @challenge)
    flash[:notice] = 'Join successfully'

    redirect_to challenge_path(@challenge)
  end

  def quit
    @challenge = Challenge.find(params[:id])
    ChallengeUserMapping.where(user: current_user, challenge: @challenge).destroy_all
    flash[:notice] = 'Quit successfully'

    redirect_to challenge_path(@challenge)
  end

  def remove_user
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @challenge = Challenge.find(params[:id])
    ChallengeUserMapping.where(user_id: params[:user_id], challenge: @challenge).destroy_all
    flash[:notice] = 'Remove successfully'

    redirect_to challenge_path(@challenge)
  end

  private

  def challenge_params
    params.require(:challenge).permit(:name, :start_date, :end_date,
                                      :min_distance, :min_pace, :min_trail_distance,
                                      :min_trail_elevation_gain, :min_trail_pace)
  end
end
