module DwpSetup

  def build_dwp_checks_with_bad_requests(yes_response = 5, bad_requests = 5)
    teardown
    create_list :benefit_check, yes_response, :yes_result
    create_list :benefit_check, bad_requests, dwp_result: 'BadRequest', error_message: 'LSCBC959: Service unavailable'
  end

  def build_dwp_checks_with_all_errors
    teardown
    create_list :benefit_check, 6, :yes_result
    create_list :benefit_check, 2, dwp_result: 'Unspecified error', error_message: 'Server broke connection'
    create_list :benefit_check, 1, dwp_result: 'BadRequest', error_message: 'LSCBC959: Service unavailable'
    create_list :benefit_check, 1, dwp_result: 'Unspecified error', error_message: '500 Internal Server Error'
  end

  private

  def teardown
    BenefitCheck.delete_all
  end
end

RSpec.configure do |c|
  c.include DwpSetup
end
