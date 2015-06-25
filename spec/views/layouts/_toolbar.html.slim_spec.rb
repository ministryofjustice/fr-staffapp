require 'rails_helper'

RSpec.describe "layouts/_toolbar.html.slim", type: :view do

  include Devise::TestHelpers

  let(:user)          { create :user }
  let(:manager)       { create :manager }
  let(:admin_user)    { create :admin_user }

  context 'logged out user' do

    before(:each) { render }

    it 'not see offices' do
      expect(rendered).to_not include('Offices')
    end

    it 'not see admin' do
      expect(rendered).to_not include('Admin')
    end
  end

  context 'logged in user' do

    before(:each) do
      sign_in user
      render
    end
    it 'can see an income check link' do
      expect(rendered).to include(t('functions.r2_calculator'))
      assert_select 'a', text: t('functions.r2_calculator').to_s, count:  1
    end

    it 'can see the guide' do
      expect(rendered).to include('Staff guide')
    end

    it 'see offices' do
      expect(rendered).to_not include('Offices')
    end

    it 'not see admin' do
      expect(rendered).to_not include('Users')
    end
  end
  context 'logged in as admin' do

    before(:each) do
      sign_in admin_user
      render
    end

    it 'see offices' do
      expect(rendered).to include('Offices')
    end

    it 'see admin' do
      expect(rendered).to include('Users')
    end
  end
  context 'logged in as manager' do

    before(:each) do
      sign_in manager
      render
    end

    it 'see offices' do
      expect(rendered).to include('My office')
    end

    it 'see admin' do
      expect(rendered).to include('Users')
    end
  end
end
