require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  include Devise::TestHelpers

  describe "GET #index" do
    let(:user)          { FactoryGirl.create :user }
    let(:manager)       { FactoryGirl.create :manager }

    context 'when the user is authenticated' do
      context 'as a user' do
        before { sign_in user }
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end
      end
      context 'as a manager' do
        before(:each) do
          DwpCheck.delete_all
          FactoryGirl.create_list :dwp_check, 2, created_by: manager, office: manager.office
          sign_in manager
          get :index
        end
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
        it 'populates a list of dwp_checks' do
          expect(assigns(:dwpchecks).count).to eql(2)
        end
      end
    end

    context 'when the user is not authenticated' do
      before { sign_out user }

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

end
