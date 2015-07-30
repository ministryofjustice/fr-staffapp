require 'rails_helper'

RSpec.describe Application, type: :model do
  let(:application)      { build :application }

  it 'has a valid factory build' do
    expect(application).to be_valid
  end

  describe 'Step 3 - Savings and investments' do
    before { application.status = 'savings_investments' }

    describe 'methods' do
      describe 'savings_investment_result' do
        context 'threshold_exceeded is true' do
          before { application.threshold_exceeded = true }

          it 'returns failed' do
            expect(application.savings_investment_result?).to eq false
          end

          context 'over_61 is true' do
            before { application.over_61 = true }

            it 'returns failed' do
              expect(application.savings_investment_result?).to eq false
            end
          end
        end

        context 'threshold_exceeded is false' do
          before { application.threshold_exceeded = false }

          it 'returns passed' do
            expect(application.savings_investment_result?).to eq true
          end
        end
        context 'threshold_exceeded is true' do
          before { application.threshold_exceeded = true }

          context 'over_61 is false' do
            before { application.over_61 = false }

            it 'returns passed' do
              expect(application.savings_investment_result?).to eq true
            end
          end
        end
      end

      describe 'threshold' do
        describe 'is set' do
          it 'to 3000 when the fee is less than 1000' do
            application.fee = '999.99'
            expect(application.threshold).to eq 3000
          end

          it 'to 3000 when the fee is equal to 1000' do
            application.fee = '1000'
            expect(application.threshold).to eq 3000
          end

          it 'to 4000 when the fee is greater than 1000' do
            application.fee = '1001.00'
            expect(application.threshold).to eq 4000
          end

          context 'when the applicant is over 61' do
            before { application.date_of_birth = Time.zone.today - 62.years }
            it 'to 16000 regardless of fee amount' do
              ['999', '1000', '1001'].each do |fee|
                application.fee = fee
                expect(application.threshold).to eq 16000
              end
            end
          end
        end
      end

      describe 'known_over_61?' do
        it 'is recognised' do
          expect(application).to respond_to :known_over_61?
        end

        context 'when applicant is over 61' do
          before { application.date_of_birth = Time.zone.today - 61.years }

          it 'returns true' do
            expect(application.known_over_61?).to eq true
          end
        end

        context 'when applicant is under 61' do
          before { application.date_of_birth = Time.zone.today - 01.years }

          it 'returns false' do
            expect(application.known_over_61?).to eq false
          end
        end
      end
    end

    describe 'validations' do
      describe 'threshold_exceeded' do
        describe 'presence' do
          before do
            application.threshold_exceeded = nil
            application.valid?
          end

          it 'must be entered' do
            expect(application).to be_invalid
          end

          it 'returns an error if missing' do
            expect(application.errors[:threshold_exceeded]).to eq ['You must answer the savings question']
          end
        end
      end

      context 'threshold_exceeded is true' do
        before { application.threshold_exceeded = true }

        describe 'over_61' do
          before do
            application.over_61 = nil
            application.valid?
          end

          it 'must be present' do
            expect(application).to be_invalid
          end
        end
      end

      context 'savings_threshold is false' do
        before { application.threshold_exceeded = false }

        describe 'over_61' do
          before do
            application.over_61 = nil
            application.valid?
          end

          it 'must be nil' do
            expect(application).to be_valid
          end

          context 'not nil' do
            before do
              application.over_61 = true
              application.valid?
            end

            it 'returns invalid' do
              expect(application).to be_invalid
            end
          end
        end
      end

      context 'when threshold_exceeded is true' do
        before { application.threshold_exceeded = true }

        context 'and over_61 is not nil' do
          before { application.over_61 = true }

          context 'setting threshold_exceeded to false' do
            before { application.threshold_exceeded = false }

            it 'resets over_61 to nil' do
              expect(application.over_61).to eq nil
            end

            it 'leaves the application as valid' do
              expect(application).to be_valid
            end
          end
        end
      end
    end
  end
end
