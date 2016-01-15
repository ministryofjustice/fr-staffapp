require 'rails_helper'

RSpec.describe "home/index.html.slim", type: :view do

  include Devise::TestHelpers

  let(:office) { create :office }
  let(:user) { create :user, office: office }

  let(:application_new?) { false }
  let(:application_index?) { false }
  let(:report_graphs?) { false }

  before do
    allow(view).to receive(:policy).with(:application).and_return(double(new?: application_new?, index?: application_index?))
    allow(view).to receive(:policy).with(:report).and_return(double(graphs?: report_graphs?))

    sign_in user

    render
  end

  subject { rendered }

  describe 'Process application box' do
    context 'when user has permissions to process application' do
      let(:application_new?) { true }

      it 'renders title' do
        is_expected.to have_text 'Process application'
      end

      context 'when the office has some jurisdictions assigned' do
        it 'renders the Start now button' do
          is_expected.to have_text 'Start now'
        end
      end

      context 'when the office has no jurisdictions assigned' do
        let(:office) { create :office, jurisdictions: [] }

        it 'renders the message that manager has to first assign jurisdictions' do
          is_expected.to have_text 'Please ask your manager to assign jurisdictions to your office.'
        end
      end
    end

    context 'when user does not have permissions to process application' do
      it 'is not rendered' do
        is_expected.not_to have_text 'Process application'
        is_expected.not_to have_link 'Start now'
      end
    end
  end

  describe 'Waiting applications' do
    context 'when user has permissions to list applications' do
      let(:application_index?) { true }

      it 'are rendered' do
        is_expected.to have_content 'Waiting for evidence'
        is_expected.to have_content 'Waiting for part-payment'
      end
    end
    context 'when user does not have permissions to list applications' do
      it 'are not rendered' do
        is_expected.not_to have_content 'Waiting for evidence'
        is_expected.not_to have_content 'Waiting for part-payment'
      end
    end
  end

  describe 'Processed and deleted applications' do
    context 'when user has permissions to list applications' do
      let(:application_index?) { true }

      it 'are rendered' do
        is_expected.to have_content 'Completed'
        is_expected.to have_link 'Processed applications', href: processed_applications_path
        is_expected.to have_link 'Deleted applications', href: deleted_applications_path
      end
    end

    context 'when user does not have permissions to list applications' do
      it 'are not rendered' do
        is_expected.not_to have_content 'Completed'
        is_expected.not_to have_link 'Processed applications', href: processed_applications_path
        is_expected.not_to have_link 'Deleted applications', href: deleted_applications_path
      end
    end
  end

  describe 'Usage graphs' do
    context 'when user has permissions to see the graphs' do
      let(:report_graphs?) { true }

      it 'are rendered' do
        is_expected.to have_xpath('//h2', text: 'Total')
      end
    end

    context 'when user does not have permissions to see the graphs' do
      it 'are not rendered' do
        is_expected.not_to have_xpath('//h2', text: 'Total')
      end
    end
  end
end
