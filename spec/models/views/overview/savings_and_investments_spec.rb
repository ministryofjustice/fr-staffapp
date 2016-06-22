# coding: utf-8
require 'rails_helper'

RSpec.describe Views::Overview::SavingsAndInvestments do

  let(:saving) { build_stubbed(:saving) }
  subject(:view) { described_class.new(saving) }

  describe '#all_fields' do
    subject { view.all_fields }

    it { is_expected.to eql %w[min_threshold_exceeded max_threshold_exceeded amount] }
  end

  describe '#min_threshold_exceeded' do
    let(:saving) { build_stubbed :saving, min_threshold_exceeded: threshold_exceeded }
    subject { view.min_threshold_exceeded }

    [true, false].each do |value|
      context "when min_threshold_exceeded is #{value}" do
        let(:threshold_exceeded) { value }
        it { is_expected.to eq I18n.t("convert_boolean.#{!value}") }
      end
    end
  end

  describe '#max_threshold_exceeded' do
    let(:saving) { build_stubbed :saving, min_threshold_exceeded: true, max_threshold_exceeded: threshold_exceeded }
    subject { view.max_threshold_exceeded }

    [true, false].each do |value|
      context "when max_threshold_exceeded is #{value}" do
        let(:threshold_exceeded) { value }
        it { is_expected.to eq I18n.t("convert_boolean.#{value}") }
      end
    end
  end

  describe '#amount' do
    let(:saving) { build_stubbed :saving, amount: 3500 }
    subject { view.amount }

    it { is_expected.to eql '£3500' }
  end
end
