# frozen_string_literal: true

class GroupsController < ApplicationController
  def index
    @q = Group.ransack(params[:q])
    @groups = @q.result(distinct: true).order(name: :ASC).paginate(page: params[:page])
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.new
  end

  def edit
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.find(params[:id])
  end

  def create
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.new(group_params)

    if @group.save
      flash[:notice] = 'Create successfully'
      redirect_to groups_path
    else
      flash[:alert] = @group.errors.full_messages
      render :new
    end
  end

  def update
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.find(params[:id])

    if @group.update(group_params)
      flash[:notice] = 'Update successfully'
      redirect_to groups_path
    else
      flash[:alert] = @group.errors.full_messages
      render :edit
    end
  end

  def destroy
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = 'Delete successfully'

    redirect_to groups_path
  end

  def join
    if current_user.team_bnr?
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.find(params[:id])
    GroupUserMapping.find_or_create_by(user: current_user, group: @group)
    flash[:notice] = 'Join successfully'

    redirect_to groups_path
  end

  def quit
    @group = Group.find(params[:id])
    GroupUserMapping.where(user: current_user, group: @group).destroy_all
    flash[:notice] = 'Quit successfully'

    redirect_to groups_path
  end

  def remove_user
    unless current_user.is_admin
      flash[:alert] = 'Unauthorization'
      redirect_to root_path
      return
    end
    @group = Group.find(params[:id])
    GroupUserMapping.where(user_id: params[:user_id], group: @group).destroy_all
    flash[:notice] = 'Remove successfully'

    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
end
