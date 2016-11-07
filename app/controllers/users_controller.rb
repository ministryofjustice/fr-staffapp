class UsersController < ApplicationController
  respond_to :html
  before_action :populate_lookups, only: [:edit, :update]

  include FlashMessageHelper

  def index
    authorize :user

    @users = policy_scope(User).sorted_by_email
  end

  def deleted
    authorize :user, :list_deleted?
    @users = policy_scope(User).only_deleted.sorted_by_email
  end

  def edit
    authorize user
  end

  def show
    authorize user
  end

  def update
    authorise_and_assign_update

    update_successful = user.save
    if update_successful && manager_setup.in_progress?
      redirect_to root_path
    else
      flash_notices_for_update(update_successful)
      user_or_redirect
    end
  end

  def destroy
    authorize user

    user.destroy
    redirect_to(action: :index)
  end

  def restore
    authorize deleted_user
    deleted_user.restore
    redirect_to redirect_after_restore
  end

  protected

  def user
    @user ||= User.find(params[:id])
  end

  def deleted_user
    @user ||= User.only_deleted.find(params[:id])
  end

  def flash_notices_for_update(update_successful)
    flash[:notice] = 'User updated' if update_successful
    flash[:notice] = user_transfer_notice if UserManagement.new(current_user, @user).transferred?
  end

  def user_params
    params.require(:user).permit([:name, :office_id, :jurisdiction_id, :role])
  end

  def user_transfer_notice
    office = @user.office
    t('error_messages.user.moved_offices',
      user: @user.name,
      office: office.name,
      contact: format_managers_contacts(office.managers))
  end

  def populate_lookups
    @roles = if current_user.admin?
               User::ROLES
             else
               User::ROLES - %w[admin]
             end
    @offices = Office.all.order(:name)
    @jurisdictions = user.office.jurisdictions
  end

  def user_or_redirect
    if UserManagement.new(current_user, @user).admin_manager_or_user_themselves?
      respond_with(@user)
    elsif current_user.manager?
      redirect_to users_path
    else
      redirect_to root_path
    end
  end

  def redirect_after_restore
    User.only_deleted.count.positive? ? deleted_users_path : users_path
  end

  def manager_setup
    @manager_setup ||= ManagerSetup.new(current_user, session)
  end

  def authorise_and_assign_update
    # this double authorisation is unusual, but I didn't find a better solution for making sure
    # that managers can't edit users from other offices, because they can transfer users to
    # other offices by this update
    authorize user, :edit?
    user.assign_attributes(user_params)
    authorize user, :update?
  end
end
