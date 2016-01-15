require 'rails_helper'

RSpec.describe Office, type: :model do

  let(:office) { build :office }

  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:applications) }
  it { is_expected.to have_many(:office_jurisdictions) }
  it { is_expected.to have_many(:jurisdictions).through(:office_jurisdictions) }

  it 'has a valid factory' do
    expect(office).to be_valid
  end

  context 'validations' do
    it 'is invalid with no name' do
      office = build(:invalid_office)
      expect(office).to_not be_valid
      expect(office.errors[:name]).to eq ['Enter the office name']
    end

    it 'must have a unique name' do
      original = create(:office)
      duplicate = build(:office, name: original.name)
      expect(duplicate).to be_invalid
    end
  end

  describe 'managers' do
    let(:office)      { FactoryGirl.create :office }

    it 'returns a list of user in the manager role' do
      User.delete_all
      FactoryGirl.create_list :user, 3, office: office
      FactoryGirl.create :manager, office: office
      expect(office.managers.count).to eql 1
    end
  end
end
