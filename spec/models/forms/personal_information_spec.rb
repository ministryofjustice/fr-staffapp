require 'rails_helper'

RSpec.describe Forms::PersonalInformation do
  params_list = %i[last_name date_of_birth married title first_name ni_number]

  let(:personal_information) { attributes_for :personal_information }
  subject { described_class.new(personal_information) }

  describe 'PERMITTED_ATTRIBUTES' do
    it 'returns a list of attributes' do
      expect(described_class::PERMITTED_ATTRIBUTES.keys).to match_array(params_list)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2) }

    it { is_expected.to validate_presence_of(:date_of_birth) }

    describe 'married' do
      context 'when true' do
        before { personal_information[:married] = true }

        it { expect(subject.valid?).to be true }
      end

      context 'when false' do
        before { personal_information[:married] = false }

        it { expect(subject.valid?).to be true }
      end

      context 'when not a boolean value' do
        before { personal_information[:married] = 'string' }

        it { expect(subject.valid?).to be false }
      end
    end

    describe 'ni_number' do
      context 'when valid' do
        before { personal_information[:ni_number] = 'AB112233A' }

        it 'passes validation' do
          expect(subject.valid?).to be true
        end
      end

      context 'when blank' do
        before { subject.ni_number = '' }

        it 'passes validation' do
          expect(subject.valid?).to be true
        end
      end

      context 'when invalid' do
        before { subject.ni_number = 'FOOBAR' }

        it 'passes validation' do
          expect(subject.valid?).to be false
        end
      end
    end
  end

  describe 'when Application object is passed in' do
    let(:application) { create :application }
    let(:form) { described_class.new(application) }

    params_list.each do |attr_name|
      it "assigns #{attr_name}" do
        expect(form.send(attr_name)).to eq application.send(attr_name)
      end
    end
  end

  describe 'when a Hash is passed in' do
    let(:hash) { attributes_for :full_personal_information }
    let(:form) { described_class.new(hash) }
    most_attribs = params_list.reject { |k, _| k == :date_of_birth }

<<<<<<< HEAD
    most_attribs.each do |attr_name|
=======
    params_list.each do |attr_name|
>>>>>>> Use a variable instead of constant
      it "assigns #{attr_name}" do
        expect(form.send(attr_name)).to eq hash[attr_name]
      end
    end

    it 'assign date_of_birth attribute' do
      expect(form.date_of_birth).to eq hash[:date_of_birth].to_date
    end
  end
end
