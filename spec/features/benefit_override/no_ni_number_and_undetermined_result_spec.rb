# coding: utf-8
require 'rails_helper'

def personal_details_without_ni_number
  login_as user
  start_new_application

  fill_in 'application_last_name', with: 'Smith'
  fill_in 'application_date_of_birth', with: Time.zone.today - 25.years
  choose 'application_married_false'
  click_button 'Next'
end

def application_details
  fill_in 'application_fee', with: 410
  find(:xpath, '(//input[starts-with(@id,"application_jurisdiction_id_")])[1]').click
  fill_in 'application_date_received', with: Time.zone.today
  click_button 'Next'
end

def savings_and_investments
  choose 'application_min_threshold_exceeded_false'
  click_button 'Next'
end

def benefits_page
  choose 'application_benefits_true'
  click_button 'Next'
end

RSpec.feature 'No NI number provided', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  let!(:jurisdictions) { create_list :jurisdiction, 3 }
  let!(:office)        { create(:office, jurisdictions: jurisdictions) }
  let!(:user)          { create(:user, jurisdiction_id: jurisdictions[1].id, office: office) }
  let(:no_remission)   { 'Not eligible for help with fees' }

  before do
    personal_details_without_ni_number
    application_details
    savings_and_investments
    benefits_page
  end

  scenario 'correct content on the page' do
    expect(page).to have_xpath('//h2', text: 'Benefits')
    expect(page).to have_content('There’s a problem with the applicant’s surname, date of birth or National Insurance number.')
  end

  context 'when the user processes paper evidence' do
    before do
      choose 'benefit_override_evidence_true'
    end

    context 'when the evidence is valid' do
      let(:full_remission) { 'Eligible for help with fees' }

      before do
        choose 'benefit_override_correct_true'
        click_button 'Next'
      end

      scenario 'has the correct title and message' do
        expect(page).to have_content 'Check details'
      end

      context 'when the user progresses to the confirmation page' do
        before { click_button 'Complete processing' }

        scenario 'shows the full remission message' do
          expect(page).to have_content full_remission
        end

        context 'when the user visits processed application page' do
          before { visit '/processed_applications' }

          scenario "shows applicant's details" do
            expect(page).to have_content 'Smith'
          end
        end
      end
    end

    context 'when the evidence is invalid' do
      before do
        choose 'benefit_override_correct_false'
        fill_in 'benefit_override_incorrect_reason', with: 'some reason'
        click_button 'Next'
      end

      scenario 'takes them the confirmation page' do
        expect(page).to have_content 'Check details'
      end

      context 'when the user progresses to the confirmation page' do
        before { click_button 'Complete processing' }

        it { expect(page).to have_content no_remission }
      end
    end
  end

  context 'when the user progresses to the summary page' do
    before do
      choose 'benefit_override_evidence_false'
      click_button 'Next'
    end

    it do
      expect(page).to have_content 'Check details'
    end

    context 'when the user completes the application' do
      before { click_button 'Complete processing' }

      it do
        expect(page).to have_content no_remission
        expect(page).to have_xpath('//div[contains(@class,"callout")]/h3[@class="heading-large"]')
        expect(page).to have_content no_remission
      end
    end
  end
end
