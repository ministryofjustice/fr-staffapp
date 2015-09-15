require 'rails_helper'

RSpec.describe DwpChecksController, type: :controller do

  include Devise::TestHelpers

  let(:user)          { create :user }
  let(:admin_user)    { create :admin_user }

  context 'logged out user' do
    describe 'GET #show' do
      it 'redirects to login page' do
        dwp_check = create(:dwp_check, created_by: user)
        get :show, unique_number: dwp_check.to_param
        expect(response).to redirect_to(user_session_path)
      end
    end

    describe 'GET #new' do
      it 'redirects to login page' do
        get :new, {}
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  context 'logged in as standard user' do

    before(:each) { sign_in user }

    describe 'GET #show' do
      let(:dwp_check) do
        create(:dwp_check, created_by: user)
      end

      xit 'assign the requested dwp_check as @dwp_check' do
        dwp_check = create(:dwp_check, created_by: user)
        get :show, unique_number: dwp_check.unique_number
        expect(assigns(:dwp_checker)).to eq(dwp_check)
        expect(response).to render_template('dwp_checks/show')
      end

      it 'redirects to home page' do
        get :show, unique_number: dwp_check.unique_number
        expect(response).to redirect_to root_path
      end

      context 'when invalid request is made' do
        let(:invalid_number) { "'" }

        xit 'throws an error when invalid request is made' do
          expect { get :show, unique_number: invalid_number }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe 'GET #new' do
      xit 'render the expected view' do
        get :new, {}
        expect(response.status).to eql(200)
        expect(response).to render_template('dwp_checks/new')
      end

      it 'redirects to home page' do
        get :new, {}
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #lookup' do

      context 'date format' do

        before(:each) do
          json = '{"original_client_ref": "unique", "benefit_checker_status": "Yes",
                  "confirmation_ref": "T1426267181940",
                  "@xmlns": "https://lsc.gov.uk/benefitchecker/service/1.0/API_1.0_Check"}'
          stub_request(:post, "#{ENV['DWP_API_PROXY']}/api/benefit_checks").
            to_return(status: 200, body: json, headers: {})
        end

        xit "doesn't accepts d/m/yy date format" do
          post :lookup, dwp_check: attributes_for(:dwp_check, dob: '1/1/80')
          expect(response).to render_template('dwp_checks/new')
        end

        it 'redirects to home page' do
          post :lookup, dwp_check: attributes_for(:dwp_check, dob: '1/1/80')
          expect(response).to redirect_to root_path
        end

        xit 'accepts dd mmmm yyyy' do
          post :lookup, dwp_check: attributes_for(:dwp_check, dob: '01 January 1980')
          expect(response).to redirect_to dwp_checks_path(DwpCheck.last.unique_number)
        end

        it 'redirects to home page' do
          post :lookup, dwp_check: attributes_for(:dwp_check, dob: '01 January 1980')
          expect(response).to redirect_to root_path
        end
      end

      context 'valid request' do

        before(:each) do
          json = '{"original_client_ref": "unique", "benefit_checker_status": "Yes",
                  "confirmation_ref": "T1426267181940",
                  "@xmlns": "https://lsc.gov.uk/benefitchecker/service/1.0/API_1.0_Check"}'
          stub_request(:post, "#{ENV['DWP_API_PROXY']}/api/benefit_checks").
            to_return(status: 200, body: json, headers: {})
          post :lookup, dwp_check: attributes_for(:dwp_check)
        end

        it 'returns the redirect status code' do
          expect(response.status).to eql(302)
        end

        xit 'redirects to the result page' do
          expect(response).to redirect_to dwp_checks_path(DwpCheck.last.unique_number)
        end

        pending 'when service encounters an error' do

          before(:each) do
            stub_request(:post, "#{ENV['DWP_API_PROXY']}/api/benefit_checks").
              to_return(status: 500, headers: {})
            post :lookup, dwp_check: attributes_for(:dwp_check)
          end

          it 're-renders the form' do
            expect(response).to render_template(:new)
          end

          it 'displays a flash message' do
            expect(flash[:alert]).to be_present
          end

          it 'displays the error description in the flash message' do
            expect(flash[:alert]).to eql('500 Internal Server Error')
          end
        end
      end

      context 'invalid request' do
        xit 're-renders the form' do
          post :lookup, dwp_check: attributes_for(:invalid_dwp_check)
          expect(response).to render_template(:new)
        end

        it 'redirects to home page' do
          post :lookup, dwp_check: attributes_for(:invalid_dwp_check)
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  context 'logged in as admin user' do

    before(:each) { sign_in admin_user }

    describe 'GET #show' do
      let(:dwp_check) { create(:dwp_check, created_by: user) }

      xit 'assign the requested dwp_check as @dwp_check' do
        dwp_check = create(:dwp_check, created_by: user)
        get :show, unique_number: dwp_check.unique_number
        expect(assigns(:dwp_checker)).to eq(dwp_check)
        expect(response).to render_template('dwp_checks/show')
      end

      it 'redirects to home page' do
        get :show, unique_number: dwp_check.unique_number
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #new' do
      xit 'render the expected view' do
        get :new, {}
        expect(response.status).to eql(200)
        expect(response).to render_template('dwp_checks/new')
      end

      it 'redirects to home page' do
        get :new, {}
        expect(response).to redirect_to root_path
      end
    end
  end
end
