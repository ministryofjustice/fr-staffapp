def base_page
  @base_page ||= BasePage.new
end

def sign_in_page
  @sign_in_page ||= SignInPage.new
end

def dashboard_page
  @dashboard_page ||= DashboardPage.new
end

def new_password_page
  @new_password_page ||= NewPasswordPage.new
end

def personal_details_page
  @personal_details_page ||= PersonalDetailsPage.new
end

def application_details_page
  @application_details_page ||= ApplicationDetailsPage.new
end

def approve_page
  @approve_page ||= ApprovePage.new
end

def find_application_page
  @find_application_page ||= FindApplicationPage.new
end

def application_page
  @application_page ||= ApplicationPage.new
end

def benefit_checker_page
  @benefit_checker_page ||= BenefitCheckerPage.new
end

def processed_applications_page
  @processed_applications_page ||= ProcessedApplicationsPage.new
end

def savings_investments_page
  @savings_investments_page ||= SavingsInvestmentsPage.new
end

def benefits_page
  @benefits_page ||= BenefitsPage.new
end

def incomes_page
  @incomes_page ||= IncomesPage.new
end

def paper_evidence_page
  @paper_evidence_page ||= PaperEvidencePage.new
end

def problem_with_evidence_page
  @problem_with_evidence_page ||= ProblemWithEvidencePage.new
end

def reason_for_rejecting_evidence_page
  @reason_for_rejecting_evidence_page ||= ReasonForRejectingEvidencePage.new
end

def part_payment_page
  @part_payment_page ||= PartPaymentPage.new
end

def summary_page
  @summary_page ||= SummaryPage.new
end

def confirmation_page
  @confirmation_page ||= ConfirmationPage.new
end

def generate_report_page
  @generate_report_page ||= GenerateReportPage.new
end

def change_user_details_page
  @change_user_details_page ||= ChangeUserDetailsPage.new
end

def profile_page
  @profile_page ||= ProfilePage.new
end

def staff_page
  @staff_page ||= StaffPage.new
end

def staff_details_page
  @staff_details_page ||= StaffDetailsPage.new
end

def office_page
  @office_page ||= OfficePage.new
end

def users_page
  @users_page ||= UsersPage.new
end

def edit_banner_page
  @edit_banner_page ||= EditBannerPage.new
end

def feedback_page
  @feedback_page ||= FeedbackPage.new
end

def letter_template_page
  @letter_template_page ||= LetterTemplatePage.new
end

def reports_page
  @reports_page ||= ReportsPage.new
end

def guide_page
  @guide_page ||= GuidePage.new
end

def dwp_message_page
  @dwp_message_page ||= DwpMessagePage.new
end

def navigation_page
  @navigation_page ||= NavigationPage.new
end

def evidence_accuracy_page
  @evidence_accuracy_page ||= EvidenceAccuracyPage.new
end

def return_letter_page
  @return_letter_page ||= ReturnLetterPage.new
end

def evidence_page
  @evidence_page ||= EvidencePage.new
end

def forbidden_page
  @forbidden_page ||= ForbiddenPage.new
end

def process_application_guide_page
  @process_application_guide_page ||= ProcessApplicationGuidePage.new
end

def evidence_checks_guide_page
  @evidence_checks_guide_page ||= EvidenceChecksGuidePage.new
end

def part_payments_guide_page
  @part_payments_guide_page ||= PartPaymentsGuidePage.new
end

def appeals_guide_page
  @appeals_guide_page ||= AppealsGuidePage.new
end

def suspected_fraud_guide_page
  @suspected_fraud_guide_page ||= SuspectedFraudGuidePage.new
end

def ho_evidence_check_page
  @ho_evidence_check_page ||= HoEvidenceCheckPage.new
end

def process_online_application_page
  @process_online_application_page ||= ProcessOnlineApplicationPage.new
end

def complete_processing
  base_page.content.complete_processing_button.click
end

def start_application
  sign_in_page.load_page
  sign_in_page.user_account
  dashboard_page.process_application
end

def go_to_finance_transactional_report_page
  visit(reports_page.url)
  reports_page.finance_transactional_report
end

def eligable_application
  personal_details_page.submit_all_personal_details_ni
  application_details_page.submit_fee_600
  savings_investments_page.submit_less_than
  benefits_page.submit_benefits_yes
  paper_evidence_page.submit_evidence_yes
  complete_processing
  click_on 'Back to start', visible: false
end

def ineligable_application
  personal_details_page.submit_required_personal_details
  application_details_page.submit_fee_300
  savings_investments_page.submit_exact_amount
  complete_processing
  click_on 'Back to start', visible: false
end

def multiple_applications
  eligable_application
  dashboard_page.process_application
  ineligable_application
end

def complete_and_back_to_start
  complete_processing
  click_on 'Back to start', visible: false
end

def part_payment_application
  dashboard_page.process_application
  personal_details_page.submit_required_personal_details
  application_details_page.submit_fee_600
  savings_investments_page.submit_less_than
  benefits_page.submit_benefits_no
  incomes_page.submit_incomes_yes_3
  complete_processing
end

def waiting_evidence_application_ni
  dashboard_page.process_application
  personal_details_page.submit_all_personal_details_ni
  application_details_page.submit_as_refund_case
  savings_investments_page.submit_less_than
  benefits_page.submit_benefits_no
  incomes_page.submit_incomes_no
  incomes_page.submit_incomes_50
  complete_and_back_to_start
end

def ho_application
  dashboard_page.process_application
  personal_details_page.submit_all_personal_details_ho
end

def refund_application
  application_details_page.submit_as_refund_case
  savings_investments_page.submit_less_than
  benefits_page.submit_benefits_no
  incomes_page.submit_incomes_no
  incomes_page.submit_incomes_50
  complete_and_back_to_start
end

def reference_prefix
  "PA#{Time.zone.now.strftime('%y')}"
end
