require 'rails_helper'

RSpec.feature 'Completing the application details page of an application form', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  let!(:jurisdictions)      { create_list :jurisdiction, 3 }
  let!(:office)             { create(:office, jurisdictions: jurisdictions) }
  let!(:user)               { create(:user, jurisdiction_id: nil, office: office) }
  let!(:user_jurisdiction)  { create(:user, jurisdiction_id: jurisdictions[1].id, office: office) }
  let(:persona)             { create(:applicant_under_61) }

  before do
    dwp_api_response 'Yes'
  end

  context 'as a signed in user with default jurisdiction', js: true do
    before do
      login_as user_jurisdiction
      start_new_application
      complete_page_as 'personal_information', persona, true
    end

    it 'renders the page' do
      expect(page).to have_xpath('//h1', text: 'Application details')
    end

    context 'submitting the form empty' do
      before { click_button 'Next' }

      scenario 'renders error' do
        expect(page).to have_xpath('//label[@class="error"]', count: '3')
      end
    end

    context 'before expanding optional fields' do
      it 'are hidden' do
        expect(page.find(:xpath, '//input[@id="application_deceased_name"]').visible?).to be false
        expect(page.find(:xpath, '//input[@id="application_day_date_fee_paid"]').visible?).to be false
      end

      context 'expanding probate' do
        before { check 'application_probate' }

        it 'shows the probate section' do
          expect(page).to have_xpath('//input[@id="application_deceased_name"]')
        end

        context 'submitting empty' do
          before { click_button 'Next' }

          scenario 'renders errors' do
            expect(page).to have_xpath('//label[@class="error"]', count: '5')
          end
        end
      end

      context 'expanding refund' do
        before { check 'application_refund' }

        it 'shows the refund section' do
          expect(page).to have_xpath('//input[@id="application_day_date_fee_paid"]')
        end

        context 'submitting empty' do
          before { click_button 'Next' }

          scenario 'renders errors' do
            # The date_fee_paid can't be validated until date_received is filled in,
            # therefore there's no error for that field
            expect(page).to have_xpath('//label[@class="error"]', count: '3')
          end
        end
      end
    end

    context 'completing the mandatory fields' do
      before { complete_page_as 'application_details', persona, true }

      context 'and submitting the form' do
        scenario 'renders the next page' do
          expect(page).to have_xpath('//h1', text: 'Savings and investments')
        end
      end
    end
  end

  context 'as a signed in user without default jurisdiction ', js: true do
    before do
      login_as user
      start_new_application
      complete_page_as 'personal_information', persona, true
    end

    it 'renders the page' do
      expect(page).to have_xpath('//h1', text: 'Application details')
    end

    context 'submitting the form empty' do
      before { click_button 'Next' }

      scenario 'renders error' do
        expect(page).to have_xpath('//label[@class="error"]', count: '4')
      end
    end
  end
end
