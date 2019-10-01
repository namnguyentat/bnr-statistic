# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order_newest.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @q = @user.activities.ransack(params[:q])
    @activities = @q.result(distinct: true).order_newest.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update!(params_user)
    flash[:notice] = 'Update successfully'

    redirect_to user_path(@user)
  end

  def destroy
    if current_user.is_admin
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = 'Delete successfully'
    else
      flash[:alert] = 'Unauthorization'
    end

    redirect_to users_path
  end

  def set_admin
    if current_user.is_admin
      @user = User.find(params[:id])
      @user.update!(is_admin: true)
      flash[:notice] = 'Update successfully'
    else
      flash[:alert] = 'Unauthorization'
    end

    redirect_to users_path
  end

  def set_bnr
    if current_user.is_admin
      @user = User.find(params[:id])
      @user.update!(team: 'BNR')
      flash[:notice] = 'Update successfully'
    else
      flash[:alert] = 'Unauthorization'
    end

    redirect_to users_path
  end

  def clear_bnr
    if current_user.is_admin
      @user = User.find(params[:id])
      @user.update!(team: nil)
      flash[:notice] = 'Update successfully'
    else
      flash[:alert] = 'Unauthorization'
    end

    redirect_to users_path
  end

  def clear_admin
    if current_user.is_admin
      @user = User.find(params[:id])
      @user.update!(is_admin: false)
      flash[:notice] = 'Update successfully'
    else
      flash[:alert] = 'Unauthorization'
    end

    redirect_to users_path
  end

  private

  def params_user
    params.require(:user).permit(:name, :email, :password)
  end
end
