class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :load_graph_data, only: [:index], if: 'user_signed_in? && current_user.admin?'

  def index
    manager_setup = ManagerSetup.new(current_user, session)
    manager_setup.finish! if manager_setup.in_progress?
  end

  private

  def load_graph_data
    @report_data = []
    Office.non_digital.each do |office|
      @report_data << {
        name: office.name,
        dwp_checks: BenefitCheck.by_office_grouped_by_type(office.id).checks_by_day
      }
    end
  end
end
