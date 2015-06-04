class UsersController < ApplicationController
  respond_to :html
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if current_user.admin?
      @users = User.sorted_by_email
    elsif current_user.manager?
      @users = User.by_office(current_user.office_id).where.not(role: 'admin').sorted_by_email
    end
  end

  def edit
    @user = User.find(params[:id])
    if current_user.admin?
      @roles = User::ROLES
    else
      @roles = User::ROLES - %w[admin]
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    flash[:notice] = 'User updated' if @user.update_attributes(user_params)
    respond_with(@user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user)
  end

protected

  def user_params
    params.require(:user).permit(:email, :role)
  end
end
