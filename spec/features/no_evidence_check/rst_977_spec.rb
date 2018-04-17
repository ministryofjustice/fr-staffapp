require 'rails_helper'

RSpec.feature 'Application is not evidence check when income is above threshold', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user }

  before do
    login_as user
  end

  context 'Non-refund application no evidence check for 10th application when income above threshold' do
    let(:application) { create :application_full_remission }

    before do
      create_list :application_full_remission, 9
    end

    scenario 'Every 10th application is not evidence check for application with income exceeding threshold' do
      start_new_application
      fill_personal_details
      fill_application_details
      fill_saving_and_investment
      fill_benefits(false)
      fill_income_above_threshold
      click_button 'Complete processing'
      expect(page).not_to have_content('Evidence of income needs to be checked for this application')
      expect(page).to have_content('✗   Not eligible for help with fees')
    end
  end

  context 'Refund application' do
    let(:application) { create :application_full_remission, :refund }

    before do
      create_list :application_full_remission, 1, :refund
    end

    scenario 'Every 2nd application is not evidence check for emergency application' do
      start_new_application
      fill_personal_details
      fill_application_refund_details
      fill_saving_and_investment
      fill_benefits(false)
      fill_income_above_threshold
      click_button 'Complete processing'
      expect(page).not_to have_content('Evidence of income needs to be checked for this application')
      expect(page).to have_content('✗   Not eligible for help with fees')
    end

    context 'Duplicate NINO with previous evidence checked' do

      let(:application) { create :application_full_remission }

      scenario 'No evidence check on duplicate NINO when income above threshold' do
        start_new_application
        fill_personal_details('SN123456D')
        fill_application_details
        fill_saving_and_investment
        fill_benefits(false)
        fill_income(false)
        expect(page).to have_text 'Check details'
        click_button 'Complete processing'
        visit home_index_url
        create_flag_check('SN123456D')
        click_button 'Start now'
        fill_personal_details('SN123456D')
        fill_application_details
        fill_saving_and_investment
        fill_benefits(false)
        fill_income_above_threshold
        click_button 'Complete processing'
        expect(page).not_to have_content('Evidence of income needs to be checked for this application')
        expect(page).to have_content('✗   Not eligible for help with fees')

      end
    end
  end
end
