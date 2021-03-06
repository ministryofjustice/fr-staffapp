require 'rails_helper'

RSpec.feature 'User profile', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create :user, name: 'Jim Halpert', office: office }
  let(:another_user) { create :user, office: create(:office) }
  let(:manager) { create :manager, office: office }
  let(:office) { create :office }

  context 'as a user' do

    before do
      login_as user
      visit '/'
    end

    scenario 'link to their profile' do
      top_right_corner = '//ul[@id="navigation"]/li/span'
      expect(page).to have_xpath("#{top_right_corner}[contains(., '#{user.name}')]")
    end

    context 'show view' do
      scenario 'view their profile' do
        click_link 'View profile'
        ['Staff details',
         user.email,
         user.role].each { |line| expect(page).to have_text line }
      end

      scenario 'only view their own profile' do
        visit user_path(another_user.id)
        expect(page).not_to have_text another_user.email
      end
    end

    context 'password edit' do
      context 'after viewing the password change page' do
        before do
          visit edit_user_registration_path user.id
          fill_in :user_current_password, with: 'password'
          fill_in :user_password_confirmation, with: 'password1'
        end

        scenario 'allow users to change their password' do
          fill_in :user_password, with: 'password1'
          click_button 'Update password'
          expect(page).to have_text 'Your account has been updated successfully'
        end

        scenario 'prompts user to set a new password' do
          click_button 'Update password'
          expect(page).to have_text 'You must enter a password'
        end
      end

      scenario 'prevent users to edit somebody elses password' do
        visit edit_user_registration_path another_user.id
        expect(page).to have_text "You don’t have permission to do this"
      end
    end

    context 'edit' do
      before { visit edit_user_path user.id }

      scenario 'their profile' do
        ['Change details',
         'Office',
         'Main jurisdiction',
         'Role'].each { |value| expect(page).to have_text value }
      end

      scenario 'their role should not be editable' do
        expect(page).not_to have_select('user[role]', options: ['User', 'Manager'])
      end
    end

    context 'update their profile' do
      let(:new_name) { 'New user name' }
      let(:new_email) { 'new_user_email@hmcts.net' }

      before do
        visit edit_user_path user.id
        fill_in 'user_name', with: new_name
        fill_in 'user_email', with: new_email
        click_button 'Save changes'
      end

      scenario 'their name and email has updated' do
        expect(page).to have_text "We have sent an email with a confirmation link to #{new_email} address."
        expect(page).to have_text "Please allow 5-10 minutes for this message to arrive."
      end
    end

    context 'update their profile with invalid email' do
      let(:new_email) { 'new_user_email@gmail.com' }

      before do
        visit edit_user_path user.id
        fill_in 'user_email', with: new_email
        click_button 'Save changes'
      end

      scenario 'email has not been updated' do
        expect(page).to have_text("You're not able to create an account with this email address. Only approved domains are allowed.")
      end
    end
  end

  context 'as a manager' do

    before do
      login_as manager
      user
      visit '/'
      click_link 'View staff'
      click_link 'Jim Halpert'
    end

    scenario 'canceling removing user dialog', js: true do
      within(:xpath, './/section[@id="content"]') do
        expect(page).to have_xpath(".//h1[contains(.,'Staff details')]")
        expect(page).to have_xpath(".//tr[1]/td[contains(.,'Jim Halpert')]")

        page.dismiss_confirm do
          click_link "Remove staff member"
        end
      end
      expect(current_path).to eql(user_path(user))
    end

    scenario 'confirm removing user dialog', js: true do
      within(:xpath, './/section[@id="content"]') do
        expect(page).to have_xpath(".//h1[contains(.,'Staff details')]")
        expect(page).to have_xpath(".//tr[1]/td[contains(.,'Jim Halpert')]")

        page.accept_confirm do
          click_link "Remove staff member"
        end
      end

      expect(current_path).to eql('/users')
      expect(page).not_to have_xpath(".//h1[contains(.,'Staff details')]")
      expect(page).to have_xpath(".//h1[contains(.,'Staff')]")
      expect(page).not_to have_text('Jim Halpert')
    end
  end
end
