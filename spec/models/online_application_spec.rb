require 'rails_helper'

RSpec.describe OnlineApplication, type: :model do
  subject(:online_application) { build :online_application }

  it { is_expected.to validate_presence_of(:date_of_birth) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:postcode) }

  it { is_expected.not_to allow_value(nil).for(:married) }
  it { is_expected.not_to allow_value(nil).for(:min_threshold_exceeded) }
  it { is_expected.not_to allow_value(nil).for(:benefits) }
  it { is_expected.not_to allow_value(nil).for(:refund) }
  it { is_expected.not_to allow_value(nil).for(:email_contact) }
  it { is_expected.not_to allow_value(nil).for(:phone_contact) }
  it { is_expected.not_to allow_value(nil).for(:post_contact) }
  it { is_expected.not_to allow_value(nil).for(:feedback_opt_in) }

  it { is_expected.to allow_value(nil).for(:probate) }

  it { is_expected.to validate_uniqueness_of(:reference) }

  describe '#ni_number validation' do
    context 'ho_number and ni_number is empty' do
      before { online_application.ni_number = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ho_number has a value and ni_number is empty' do
      before do
        online_application.ni_number = nil
        online_application.ho_number = 'L123456'
      end

      it { is_expected.to be_valid }
    end

    context 'ho_number in empty and ni_number is is valid' do
      before do
        online_application.ni_number = 'SN123456C'
        online_application.ho_number = nil
      end

      it { is_expected.to be_valid }
    end
  end

  describe '#full_name' do
    subject { online_application.full_name }

    let(:online_application) { build(:online_application, first_name: 'Mary', last_name: 'Smith', title: title) }

    context 'when title is present' do
      let(:title) { 'Mrs.' }

      it 'returns title, first_name and last_name separated by spaced' do
        is_expected.to eql('Mrs. Mary Smith')
      end
    end

    context 'when title is not present' do
      let(:title) { nil }

      it 'returns first_name and last_name separated by spaced' do
        is_expected.to eql('Mary Smith')
      end
    end
  end

  describe '#processed?' do

    subject { online_application.processed? }

    context 'when an application exists that is linked to this online_application' do
      let(:online_application) { create :online_application, :completed, :with_reference, convert_to_application: true }

      it { is_expected.to be true }
    end

    context 'when no application exists that is linked to this online_application' do
      let(:online_application) { create :online_application, :completed, :with_reference }

      it { is_expected.to be false }
    end
  end

  describe '#linked_application' do

    subject { online_application.linked_application }

    context 'when an application exists that is linked to this online_application' do
      let(:online_application) { create :online_application, :completed, :with_reference, convert_to_application: true }

      it { is_expected.to eql Application.find_by(reference: online_application.reference) }
    end

    context 'when no application exists that is linked to this online_application' do
      let(:online_application) { create :online_application, :completed, :with_reference }

      it { is_expected.to be nil }
    end
  end
end
