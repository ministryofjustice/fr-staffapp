require 'rails_helper'

RSpec.describe Evidence::Forms::Evidence do
  params_list = %i[correct reason]

  let(:evidence) { { correct: true } }
  subject { described_class.new(evidence) }

  describe '.permitted_attributes' do
    it 'returns a list of attributes' do
      expect(described_class.permitted_attributes.keys).to match_array(params_list)
    end
  end

  describe 'validations' do
    context 'when true' do
      let(:evidence) { { correct: true } }

      it { expect(subject.valid?).to be true }

      describe 'the reason' do
        let(:evidence) { { correct: true, reason: 'some reason' } }

        it { expect(subject.valid?).to be false }
      end
    end

    context 'when false' do
      let(:evidence) { { correct: false } }

      it { expect(subject.valid?).to be true }
    end

    context 'when not a boolean value' do
      let(:evidence) { { correct: 'some string' } }

      it { expect(subject.valid?).to be false }
    end
  end
end
