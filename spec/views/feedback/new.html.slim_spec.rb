require 'rails_helper'

RSpec.describe 'feedback/new.html.slim', type: :view do
  include Devise::TestHelpers

  let(:user)          { FactoryGirl.create :user }
  let(:feedback)      { FactoryGirl.build :feedback }

  it 'contain the required fields' do
    sign_in user
    @feedback = feedback
    render
    assert_select 'form label', text: t('activerecord.attributes.feedback.experience').to_s, count:  1
    assert_select 'form label', text: t('activerecord.attributes.feedback.ideas').to_s, count:  1
    assert_select 'form label', text: t('activerecord.attributes.feedback.rating').to_s, count:  1
    assert_select 'form label', text: t('activerecord.attributes.feedback.help').to_s, count:  1
  end
end
