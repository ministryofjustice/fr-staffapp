FactoryBot.define do
  factory :benefit_check do
    last_name { "Smith" }
    date_of_birth { Time.zone.today - 20.years }
    ni_number { "AB123456C" }
    date_to_check { Time.zone.yesterday }
    our_api_token { 'name@20150101.ab12-cd34' }
    benefits_valid { true }
    application

    factory :invalid_benefit_check do
      last_name { nil }
    end

    trait :yes_result do
      dwp_result { 'Yes' }
    end

    trait :no_result do
      dwp_result { 'No' }
    end

    trait :error_result do
      dwp_result { 'Error' }
    end
  end
end
