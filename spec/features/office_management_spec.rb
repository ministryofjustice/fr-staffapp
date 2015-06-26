require 'rails_helper'

RSpec.feature 'Office management', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user)          { create :user }
  let(:admin_user)    { create :admin_user }

  context 'Admin user' do
    scenario 'creates a new office' do

      new_court = 'new court'

      login_as(admin_user, scope: :user)
      visit new_office_path

      fill_in 'office_name', with: new_court
      click_button 'Create Office'

      expect(page).to have_xpath('//label', text: 'Name')
      expect(page).to have_xpath('//div', text: new_court)
    end
  end
end
