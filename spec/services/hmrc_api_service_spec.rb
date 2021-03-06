# coding: utf-8

require 'rails_helper'

describe HmrcApiService do
  subject(:service) { described_class.new(application) }
  let(:application) { create :application_part_remission, applicant: applicant }
  let(:applicant) {
    create :applicant,
           date_of_birth: DateTime.new(1968, 2, 28),
           ni_number: 'AB123456C',
           first_name: 'Jimmy',
           last_name: 'Conners'
  }
  let(:hmrc_api) { instance_double(HwfHmrcApi::Connection) }
  let(:hmrc_api_authentication) { instance_double(HwfHmrcApi::Authentication, access_token: 1, expires_in: 1) }

  describe "HMRC API gem" do
    before do
      ENV['HMRC_SECRET'] = 'secret'
      ENV['HMRC_TTP_SECRET'] = 'base32secret3232'
      ENV['HMRC_CLIENT_ID'] = '12345'
      allow(hmrc_api).to receive(:authentication).and_return hmrc_api_authentication
    end

    context 'ENV variables' do
      it "without token" do
        allow(HwfHmrcApi).to receive(:new).and_return hmrc_api
        allow(hmrc_api).to receive(:match_user)
        service
        expect(HwfHmrcApi).to have_received(:new).with({ hmrc_secret: "secret", totp_secret: "base32secret3232", client_id: "12345" })
      end

      context 'stored token' do
        before {
          allow(HmrcToken).to receive(:last).and_return hmrc_token
          allow(HwfHmrcApi).to receive(:new).and_return hmrc_api
          allow(hmrc_api).to receive(:match_user)
        }
        let(:expires_in) { Time.zone.parse('01-02-2021 10:50') }
        let(:hmrc_token) { HmrcToken.create(access_token: '123456', expires_in: expires_in) }

        it "expired" do
          allow(hmrc_token).to receive(:expired?).and_return true
          service
          expect(HwfHmrcApi).to have_received(:new).with({ hmrc_secret: "secret", totp_secret: "base32secret3232", client_id: "12345" })
        end

        it "valid" do
          allow(hmrc_token).to receive(:expired?).and_return false
          service
          expect(HwfHmrcApi).to have_received(:new).with({
                                                           hmrc_secret: "secret",
                                                           totp_secret: "base32secret3232",
                                                           client_id: "12345",
                                                           access_token: '123456',
                                                           expires_in: expires_in
                                                         })
        end

        context 'update token in DB' do
          context 'token changed' do
            before do
              allow(hmrc_token).to receive(:expired?).and_return false
              allow(hmrc_api_authentication).to receive(:access_token).and_return '111333'
              allow(hmrc_api_authentication).to receive(:expires_in).and_return Time.zone.parse('01-03-2021 10:50')
              service
            end

            it { expect(HmrcToken.last.access_token).to eq '111333' }
            it { expect(HmrcToken.last.expires_in).to eq Time.zone.parse('01-03-2021 10:50') }
          end

          context 'token changed' do
            before do
              allow(hmrc_token).to receive(:expired?).and_return false
              allow(hmrc_api_authentication).to receive(:access_token).and_return '123456'
              allow(hmrc_api_authentication).to receive(:expires_in).and_return Time.zone.parse('01-03-2021 10:50')
              service
            end

            it { expect(HmrcToken.last.access_token).to eq '123456' }
            it { expect(HmrcToken.last.expires_in).to eq expires_in }
          end

        end
      end
    end

    context 'match_user' do
      let(:applicant_info) {
        {
          dob: "1968-02-28",
          nino: 'AB123456C',
          first_name: "Jimmy",
          last_name: "Conners"
        }
      }

      it "applicant params" do
        allow(HwfHmrcApi).to receive(:new).and_return hmrc_api
        allow(hmrc_api).to receive(:match_user)
        service
        expect(hmrc_api).to have_received(:match_user).with(applicant_info)
      end
    end

    context "Get data for" do
      before {
        allow(HwfHmrcApi).to receive(:new).and_return hmrc_api
        allow(hmrc_api).to receive(:match_user)
      }

      it "income" do
        allow(hmrc_api).to receive(:paye)
        service.income('2020-02-28', '2020-03-30')
        expect(hmrc_api).to have_received(:paye).with('2020-02-28', '2020-03-30')
      end

      it "address" do
        allow(hmrc_api).to receive(:addresses)
        service.address('2020-02-28', '2020-03-30')
        expect(hmrc_api).to have_received(:addresses).with('2020-02-28', '2020-03-30')
      end

      it "employment" do
        allow(hmrc_api).to receive(:employments)
        service.employment('2020-02-28', '2020-03-30')
        expect(hmrc_api).to have_received(:employments).with('2020-02-28', '2020-03-30')
      end

      it "tax_credit" do
        allow(hmrc_api).to receive(:working_tax_credits)
        service.tax_credit('2020-02-28', '2020-03-30')
        expect(hmrc_api).to have_received(:working_tax_credits).with('2020-02-28', '2020-03-30')
      end
    end

    context "Store data for" do
      before {
        allow(HwfHmrcApi).to receive(:new).and_return hmrc_api
        allow(hmrc_api).to receive(:match_user)
      }

      it "income" do
        allow(hmrc_api).to receive(:paye).and_return({ startDate: "2019-01-01" })
        service.income('2020-02-28', '2020-03-30')
        expect(service.hmrc_check.income[:startDate]).to eq "2019-01-01"
      end

      it "address" do
        allow(hmrc_api).to receive(:addresses).and_return({ endDate: "2019-01-01" })
        service.address('2020-02-28', '2020-03-30')
        expect(service.hmrc_check.address[:endDate]).to eq "2019-01-01"
      end

      it "employment" do
        allow(hmrc_api).to receive(:employments).and_return({ startDate: "2019-01-02" })
        service.employment('2020-02-28', '2020-03-30')
        expect(service.hmrc_check.employment[:startDate]).to eq "2019-01-02"
      end

      it "tax_credit" do
        allow(hmrc_api).to receive(:working_tax_credits).and_return({ endDate: "2019-01-02" })
        service.tax_credit('2020-02-28', '2020-03-30')
        expect(service.hmrc_check.tax_credit[:endDate]).to eq "2019-01-02"
      end
    end
  end
end
