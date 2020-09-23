class SignInPage < BasePage
  include Warden::Test::Helpers
  Warden.test_mode!

  set_url '/'

  section :content, '#content' do
    element :user_email, '#user_email'
    element :user_password, '#user_password'
    element :sign_in_title, 'h1', text: 'Sign in'
    element :sign_in_button, 'input[value="Sign in"]'
    element :sign_in_alert, '.govuk-error-summary', text: 'You need to sign in before continuing.'
    element :forgot_your_password, 'a', text: 'Forgot your password?'
    section :guidance, '.guidance' do
      element :get_help_header, 'h2', text: 'Get help'
      element :forgot_password, 'p', text: 'Forgot your password'
      element :follow_steps, 'p', text: 'Follow these steps to '
      element :get_new_password_link, 'a', text: 'get a new password'
      element :no_account, 'p', text: 'Don\'t have an account'
      element :contact_manager, 'p', text: 'Contact your manager to set up your account.'
      element :technical_issues, 'p', text: 'Having technical issues'
      element :email_support, 'a', text: 'Email support'
    end
  end

  def sign_in
    content.sign_in_button.click
  end

  def user_account_with_applications
    user = FactoryBot.create(:user)
    100.times do
      FactoryBot.create(:application, :processed_state, office: user.office, user: user)
    end
    sign_in_with user.email, user.password
    user
  end

  def reader_account
    user = FactoryBot.create(:reader)
    sign_in_with user.email, user.password
    user
  end

  def user_account
    user = FactoryBot.create(:user)
    sign_in_with user.email, user.password
    user
  end

  def admin_account
    user = FactoryBot.create(:admin_user)
    sign_in_with user.email, user.password
    user
  end

  def manager_account
    user = FactoryBot.create(:manager)
    sign_in_with user.email, user.password
    user
  end

  def invalid_credentials
    sign_in_with 'invalid.com', 'password'
    self
  end

  def sign_in_with(email, password)
    content.user_email.set email
    content.user_password.set password
    sign_in

    DashboardPage.new
  end
end
