FactoryGirl.define do
  factory :dwp_check do
    last_name "Smith"
    dob Time.zone.today - 20.years
    ni_number "AB123456C"
    date_to_check Time.zone.yesterday
    checked_by nil
    laa_code nil
    unique_number nil
    our_api_token 'name@20150101.ab12-cd34'
    association :office

    factory :invalid_dwp_check do
      last_name nil
    end
  end
end
