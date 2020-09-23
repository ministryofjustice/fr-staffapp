class DashboardPage < BasePage
  element :welcome_user, 'span', text: 'Welcome user'
  element :dwp_offline_banner, '.dwp-banner-offline', text: 'DWP checkerYou can’t check an applicant’s benefits. We’re investigating this issue.'
  element :dwp_online_banner, '.dwp-banner-online', text: 'DWP checkerYou can process benefits and income based applications.'
  element :help_with_fees_home, 'a', text: 'Help with fees'
  section :content, '#content' do
    element :generate_reports, 'h3', text: 'Generate reports'
    element :view_offices, 'h3', text: 'View offices'
    element :your_last_applications, 'h3', text: 'Your last applications'
    element :in_progress_applications, 'h3', text: 'In progress'
    element :completed_applications, 'h3', text: 'Completed'
    element :alert_title, '.govuk-error-summary__title'
    element :alert_text, '.alert'
    element :look_up_button, 'input[value="Look up"]'
    element :start_now_button, 'input[value="Start now"]', visible: false
    element :processed_applications, 'a', text: 'Processed applications'
    elements :last_application, '.govuk-table__row'
    element :last_application_link, 'a', text: '1'
    element :waiting_for_evidence_application_link, 'a', text: 'AB001-20-'
    element :updated_applications, '.updated_applications', text: 'Mr John Christopher Smith'
    element :generate_reports_button, '.button', text: 'Generate reports'
    element :deleted_applications, 'a', text: 'Deleted applications'
    element :online_search_reference, '#online_search_reference'
    element :process_when_back_online_heading, 'h3', text: 'Process when DWP is back online'
    element :pending_applications_link, 'a', class: 'dwp-failed-applications', text: 'Pending applications to be processed'
    element :no_pending_applications_text, 'p', text: 'No pending applications in the list'
    section :dwp_down_warning, '.dwp-down' do
      element :paragraph, 'p', text: 'You can only process:'
      element :bullet1, 'li', text: 'income-based applications'
      element :bullet2, 'li', text: 'benefits-based applications if the applicant has provided paper evidence'
    end
  end

  def look_up_reference(reference)
    content.online_search_reference.set reference
    content.look_up_button.click
  end

  def look_up_invalid_reference
    content.online_search_reference.set 'invalid'
    content.look_up_button.click
  end

  def process_application
    content.start_now_button.click
  end

  def generate_reports
    content.generate_reports_button.click
  end

  def go_home
    help_with_fees_home.click
  end

  def go_to_pending_applications
    content.pending_applications_link.click
  end
end
