class ProcessedApplicationsController < ApplicationController
  include ProcessedViewsHelper

  def index
    authorize :application

    @applications = paginated_applications.map do |application|
      Views::ApplicationList.new(application)
    end
  end

  def show
    authorize application

    @form = Forms::Application::Delete.new(application)
    assign_views
  end

  def update
    @form = Forms::Application::Delete.new(application)
    @form.update_attributes(delete_params)
    authorize application
    save_and_respond_on_update
  end

  private

  def application
    @application ||= Application.find(params[:id])
  end

  def paginated_applications
    @paginate ||= paginate(
      policy_scope(query_object)
    )
  end

  def delete_params
    params.require(:application).permit(*Forms::Application::Delete.permitted_attributes.keys)
  end

  def save_and_respond_on_update
    if @form.save
      ResolverService.new(application, current_user).delete
      flash[:notice] = 'The application has been deleted'
      redirect_to(action: :index)
    else
      assign_views
      render :show
    end
  end

  def sort_order
    return nil if params['sort'].blank?

    case params['sort']
    when 'received_asc', 'received_desc'
      Application.sort_received(params['sort'])
    when 'processed_asc', 'processed_desc'
      Application.sort_processed(params['sort'])
    when 'fee_asc', 'fee_desc'
      Application.sort_fee(params['sort'])
    end
  end

  def query_object
    if params['reference']
      Query::ProcessedApplications.new(current_user, sort_order).search(params['reference'])
    else
      Query::ProcessedApplications.new(current_user, sort_order).find
    end
  end
end
