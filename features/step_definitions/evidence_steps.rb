And("I am on an application waiting for evidence") do
  waiting_evidence_application
  waiting_evidence_application
  click_link('PA19-000002')
end

When("I click on start now") do
  click_link('Start now')
end

Then("I should be taken to a page asking me if the evidence ready to process") do
  expect(current_path).to include '/evidence/1/accuracy'
  expect(evidence_accuracy_page.content).to have_header
end

When("I click on what to do if the evidence cannot be processed") do
  evidence_accuracy_page.content.evidence_can_not_be_processed.click
end

Then("I should see instructions with a deadline to submit the evidence") do
  date_received = (Time.zone.now + 2.weeks).strftime("%Y-%m-%d")
  expect(evidence_accuracy_page.content.evidence_deadline.text).to have_content "Evidence needs to arrive by #{date_received}"
end

Then("I should see the applicants personal details") do
  expect(evidence_accuracy_page.content).to have_personal_details
end

Then("I should see the application details") do
  expect(evidence_accuracy_page.content).to have_application_details
end

Then("I should see the applicants benefit details") do
  expect(evidence_accuracy_page.content).to have_benefits
end

Then("I should see the applicants income details") do
  expect(evidence_accuracy_page.content).to have_income
end

Then("I should see whather the applicant is eligible for help with fees") do
  expect(evidence_accuracy_page.content).to have_eligibility
end

Then("I should see the processing summmary") do
  date_processed = Time.zone.now.strftime('%d %B %Y')
  expect(evidence_accuracy_page.content).to have_processing_summary
  expect(page.text).to have_content date_processed
end

When("I click on return application") do
  evidence_accuracy_page.content.evidence_can_not_be_processed.click
  click_link('Return application')
end

Then("I should be taken to the return letter page") do
  expect(current_path).to include '/evidence/1/return_letter'
  expect(return_letter_page.content).to have_header
end

Then("when I click on finish") do
  click_button('Finish')
end

Then("I should see a return application letter template") do
  expect(return_letter_page.content.evidence_confirmation_letter.text).to include 'Reference: PA19-000002'
end

When("I submit that the evidence is correct") do
  evidence_accuracy_page.content.correct_evidence.click
  next_page
end

Then("I should be taken to the evidence income page") do
  expect(current_path).to include '/evidence/1/income'
  expect(evidence_page.content).to have_header
end

When(/^I submit (\d+) as the income$/) do |income|
  fill_in 'Total monthly income from evidence', with: income
  next_page
end

Then("I see that the applicant is eligible for help with fees") do
  expect(evidence_page.content).to have_eligable_header
end

Then("I see that the applicant is not eligible for help with fees") do
  expect(evidence_page.content).to have_not_eligable_header
end

When("I submit that there is a problem with evidence") do
  evidence_accuracy_page.content.problem_with_evidence.click
  next_page
end

When("I give a reason why there is a problem") do
  fill_in 'Describe the problem with the evidence', with: 'Test is the reason'
  next_page
end

When("I do not give a reason") do
  next_page
end

Then("I should see this question must be answered error message") do
  expect(evidence_accuracy_page.content).to have_answer_question_error
end

Then("I see that the applicant needs to make a payment towards the fee") do
  expect(evidence_page.content).to have_part_payment
end

Given("I have successfully submitted the evidence") do
  click_link('Start now')
  evidence_accuracy_page.content.correct_evidence.click
  next_page
  fill_in 'Total monthly income from evidence', with: '500'
  next_page
  click_link('Next')
end

Given("I should see the evidence details on the summary page") do
  expect(current_path).to include '/evidence/1/summary'
  expect(evidence_page.content.evidence_summary).to have_evidence_header
  expect(evidence_page.content.evidence_summary).to have_change_application_evidence
  expect(evidence_page.content.evidence_summary.evidence_answer[1].text).to eq 'Correct Yes'
  expect(evidence_page.content.evidence_summary.evidence_answer[2].text).to eq 'Income £500'
end

When("I complete processing") do
  complete_processing
  back_to_start
end