FactoryBot.define do
  factory :hmrc_check do
    address { { address: { line1: Faker::Address.street_address } } }
    employment { { startDate: Faker::Date.in_date_period, endDate: Faker::Date.in_date_period } }
    income { { taxReturns: [{ taxYear: "2018-19", summary: [{ totalIncome: Faker::Number.decimal(l_digits: 2) }] }] } }
    tax_credit { { id: Faker::Number.number(digits: 10), awards: [{ payProfCalcDate: Faker::Date.in_date_period }] } }
    application
    ni_number { 'SN789456C' }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
