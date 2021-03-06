require 'rails_helper'

RSpec.describe Query::DeletedApplications, type: :model do
  subject(:query) { described_class.new(user) }

  let(:office) { create(:office) }
  let(:user) { create :user, office: office }

  describe '#find' do
    subject { query.find }

    let(:application1) { create :application_full_remission, office: office }
    let!(:application2) { create :application_full_remission, :deleted_state, office: office, deleted_at: Time.zone.parse('2015-10-19') }
    let(:other_office_application) { create :application_full_remission, :processed_state }
    let!(:application3) { create :application_full_remission, :deleted_state, office: office, deleted_at: Time.zone.parse('2016-02-29') }

    it "contains applications completely deleted from user's office in descending order of deletion" do
      is_expected.to eq([application3, application2])
    end
  end
end
