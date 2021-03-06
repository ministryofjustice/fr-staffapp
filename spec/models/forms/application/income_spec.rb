require 'rails_helper'

RSpec.describe Forms::Application::Income do
  subject { described_class.new(hash) }

  params_list = [:income, :dependents, :children]

  describe '.permitted_attributes' do
    it 'returns a list of attributes' do
      expect(described_class.permitted_attributes.keys).to match_array(params_list)
    end
  end

  describe 'validation' do
    let(:income) { described_class.new(hash) }

    describe 'income' do
      let(:hash) { { income: 500, dependents: true, children: 1 } }

      it { is_expected.to validate_presence_of(:income) }
      it { is_expected.to validate_numericality_of(:income) }
    end

    describe 'dependents' do
      let(:hash) { { income: 500, dependents: dependents, children: 1 } }

      context 'when true' do
        let(:dependents) { true }

        it { expect(income.valid?).to be true }
      end

      context 'when false' do
        let(:dependents) { false }

        it { expect(income.valid?).to be false }
      end

      context 'when not a boolean value' do
        let(:dependents) { 'string' }

        it { expect(income.valid?).to be false }
      end
    end

    describe 'children' do
      let(:hash) { { income: 500, dependents: dependents, children: children } }

      context 'when there are dependents' do
        let(:dependents) { true }

        context 'and the number of children is valid' do
          let(:children) { 1 }

          it { expect(income.valid?).to be true }
        end

        context 'and the number of children is invalid' do
          let(:children) { 0 }

          it { expect(income.valid?).to be false }
        end
      end

      context 'when there are no dependents' do
        let(:dependents) { false }

        context 'and the number of children is bigger than zero' do
          let(:children) { 1 }

          it { expect(income.valid?).to be false }
        end

        context 'and the number of children is zero' do
          let(:children) { 0 }

          it { expect(income.valid?).to be true }
        end
      end
    end
  end

  describe '#save' do
    subject(:form) { described_class.new(application) }

    subject(:update_form) do
      form.update_attributes(params)
      form.save
    end

    let(:application) { create :application }

    context 'when attributes are correct' do
      let(:params) { { income: 500, dependents: true, children: 2 } }

      it { is_expected.to be true }

      before do
        update_form
        application.reload
      end

      it 'saves the parameters in the detail' do
        params.each do |key, value|
          expect(application.send(key)).to eql(value)
        end
      end

      it 'marks the application as income' do
        expect(application.application_type).to eql('income')
      end
    end

    context 'when attributes are incorrect' do
      let(:params) { { dependents: nil } }

      it { is_expected.to be false }
    end
  end
end
