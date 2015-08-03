#=require 'income_calculator'

runScenario=(t) ->
  it "id #{t.id} passes", ->
    calc = new incomeCalculator()
    match = calc.calculate(t.fee, t.married_status, t.children, t.income)
    expect(match.type).toEqual(t.type)
    expect(match.to_pay).toEqual(t.they_pay)

describe "income_calculator", ->
  calc = {}
  seed_data = [
    { id: 1, fee: '100', married_status: true, children: '0', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 2, fee: '100', married_status: true, children: '0', income: '1200', remit: '100', they_pay: '£0', type: 'full', },
    { id: 3, fee: '100', married_status: true, children: '0', income: '1300', remit: '75', they_pay: '£25', type: 'part', },
    { id: 4, fee: '100', married_status: true, children: '0', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 5, fee: '100', married_status: true, children: '1', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 6, fee: '100', married_status: true, children: '1', income: '1500', remit: '95', they_pay: '£5', type: 'part', },
    { id: 7, fee: '100', married_status: false, children: '2', income: '1500', remit: '100', they_pay: '£0', type: 'full', },
    { id: 8, fee: '100', married_status: true, children: '1', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 9, fee: '100', married_status: true, children: '2', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 10, fee: '410', married_status: true, children: '1', income: '1500', remit: '405', they_pay: '£5', type: 'part', },
    { id: 11, fee: '410', married_status: false, children: '2', income: '1500', remit: '410', they_pay: '£0', type: 'full', },
    { id: 12, fee: '100', married_status: true, children: '2', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 13, fee: '100', married_status: true, children: '3', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 14, fee: '100', married_status: true, children: '3', income: '1900', remit: '100', they_pay: '£0', type: 'full', },
    { id: 15, fee: '100', married_status: false, children: '3', income: '1900', remit: '60', they_pay: '£40', type: 'part', },
    { id: 16, fee: '100', married_status: true, children: '3', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 17, fee: '100', married_status: true, children: '4', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 18, fee: '100', married_status: true, children: '4', income: '2200', remit: '100', they_pay: '£0', type: 'full', },
    { id: 19, fee: '100', married_status: true, children: '4', income: '2300', remit: '65', they_pay: '£35', type: 'part', },
    { id: 20, fee: '100', married_status: true, children: '4', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 21, fee: '100', married_status: true, children: '5', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 22, fee: '100', married_status: true, children: '5', income: '2400', remit: '100', they_pay: '£0', type: 'full', },
    { id: 23, fee: '100', married_status: true, children: '5', income: '2500', remit: '85', they_pay: '£15', type: 'part', },
    { id: 24, fee: '100', married_status: true, children: '5', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 25, fee: '100', married_status: true, children: '6', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 26, fee: '100', married_status: true, children: '6', income: '2700', remit: '100', they_pay: '£0', type: 'full', },
    { id: 27, fee: '100', married_status: true, children: '6', income: '2800', remit: '60', they_pay: '£40', type: 'part', },
    { id: 28, fee: '100', married_status: true, children: '6', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 29, fee: '100', married_status: false, children: '0', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 30, fee: '100', married_status: false, children: '0', income: '1000', remit: '100', they_pay: '£0', type: 'full', },
    { id: 31, fee: '100', married_status: false, children: '0', income: '1100', remit: '95', they_pay: '£5', type: 'part', },
    { id: 32, fee: '100', married_status: false, children: '0', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 33, fee: '100', married_status: false, children: '1', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 34, fee: '100', married_status: false, children: '1', income: '1300', remit: '100', they_pay: '£0', type: 'full', },
    { id: 35, fee: '100', married_status: false, children: '1', income: '1400', remit: '65', they_pay: '£35', type: 'part', },
    { id: 36, fee: '100', married_status: false, children: '1', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 37, fee: '100', married_status: false, children: '2', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 38, fee: '100', married_status: true, children: '1', income: '1600', remit: '45', they_pay: '£55', type: 'part', },
    { id: 39, fee: '100', married_status: false, children: '2', income: '1600', remit: '90', they_pay: '£10', type: 'part', },
    { id: 40, fee: '100', married_status: false, children: '2', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 41, fee: '100', married_status: false, children: '3', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 42, fee: '410', married_status: true, children: '1', income: '1600', remit: '355', they_pay: '£55', type: 'part', },
    { id: 43, fee: '410', married_status: true, children: '3', income: '1900', remit: '410', they_pay: '£0', type: 'full', },
    { id: 44, fee: '100', married_status: false, children: '3', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 45, fee: '100', married_status: false, children: '4', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 46, fee: '410', married_status: false, children: '3', income: '1900', remit: '370', they_pay: '£40', type: 'part', },
    { id: 47, fee: '100', married_status: false, children: '4', income: '2100', remit: '85', they_pay: '£15', type: 'part', },
    { id: 48, fee: '100', married_status: false, children: '4', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 49, fee: '100', married_status: false, children: '5', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 50, fee: '100', married_status: false, children: '5', income: '2300', remit: '100', they_pay: '£0', type: 'full', },
    { id: 51, fee: '100', married_status: false, children: '5', income: '2400', remit: '55', they_pay: '£45', type: 'part', },
    { id: 52, fee: '100', married_status: false, children: '5', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 53, fee: '100', married_status: false, children: '6', income: '100', remit: '100', they_pay: '£0', type: 'full', },
    { id: 54, fee: '100', married_status: false, children: '6', income: '2500', remit: '100', they_pay: '£0', type: 'full', },
    { id: 55, fee: '100', married_status: false, children: '6', income: '2600', remit: '80', they_pay: '£20', type: 'part', },
    { id: 56, fee: '100', married_status: false, children: '6', income: '3000', remit: '0', they_pay: '£100', type: 'none', },
    { id: 57, fee: '410', married_status: true, children: '0', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 58, fee: '410', married_status: true, children: '0', income: '1200', remit: '410', they_pay: '£0', type: 'full', },
    { id: 59, fee: '410', married_status: true, children: '0', income: '1300', remit: '385', they_pay: '£25', type: 'part', },
    { id: 60, fee: '410', married_status: true, children: '0', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 61, fee: '410', married_status: true, children: '1', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 62, fee: '410', married_status: false, children: '2', income: '1600', remit: '400', they_pay: '£10', type: 'part', },
    { id: 63, fee: '100', married_status: true, children: '2', income: '1700', remit: '100', they_pay: '£0', type: 'full', },
    { id: 64, fee: '410', married_status: true, children: '1', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 65, fee: '410', married_status: true, children: '2', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 66, fee: '410', married_status: true, children: '2', income: '1700', remit: '410', they_pay: '£0', type: 'full', },
    { id: 67, fee: '100', married_status: true, children: '2', income: '1800', remit: '70', they_pay: '£30', type: 'part', },
    { id: 68, fee: '410', married_status: true, children: '2', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 69, fee: '410', married_status: true, children: '3', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 70, fee: '100', married_status: true, children: '3', income: '2000', remit: '90', they_pay: '£10', type: 'part', },
    { id: 71, fee: '100', married_status: false, children: '4', income: '2000', remit: '100', they_pay: '£0', type: 'full', },
    { id: 72, fee: '410', married_status: true, children: '3', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 73, fee: '410', married_status: true, children: '4', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 74, fee: '410', married_status: true, children: '4', income: '2200', remit: '410', they_pay: '£0', type: 'full', },
    { id: 75, fee: '410', married_status: true, children: '4', income: '2300', remit: '375', they_pay: '£35', type: 'part', },
    { id: 76, fee: '410', married_status: true, children: '4', income: '3000', remit: '25', they_pay: '£385', type: 'part', },
    { id: 77, fee: '410', married_status: true, children: '5', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 78, fee: '410', married_status: true, children: '5', income: '2400', remit: '410', they_pay: '£0', type: 'full', },
    { id: 79, fee: '410', married_status: true, children: '5', income: '2500', remit: '395', they_pay: '£15', type: 'part', },
    { id: 80, fee: '410', married_status: true, children: '5', income: '3000', remit: '145', they_pay: '£265', type: 'part', },
    { id: 81, fee: '410', married_status: true, children: '6', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 82, fee: '410', married_status: true, children: '6', income: '2700', remit: '410', they_pay: '£0', type: 'full', },
    { id: 83, fee: '410', married_status: true, children: '6', income: '2800', remit: '370', they_pay: '£40', type: 'part', },
    { id: 84, fee: '410', married_status: true, children: '6', income: '3000', remit: '270', they_pay: '£140', type: 'part', },
    { id: 85, fee: '410', married_status: false, children: '0', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 86, fee: '410', married_status: false, children: '0', income: '1000', remit: '410', they_pay: '£0', type: 'full', },
    { id: 87, fee: '410', married_status: false, children: '0', income: '1100', remit: '405', they_pay: '£5', type: 'part', },
    { id: 88, fee: '410', married_status: false, children: '0', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 89, fee: '410', married_status: false, children: '1', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 90, fee: '410', married_status: false, children: '1', income: '1300', remit: '410', they_pay: '£0', type: 'full', },
    { id: 91, fee: '410', married_status: false, children: '1', income: '1400', remit: '375', they_pay: '£35', type: 'part', },
    { id: 92, fee: '410', married_status: false, children: '1', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 93, fee: '410', married_status: false, children: '2', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 94, fee: '100', married_status: false, children: '3', income: '1800', remit: '100', they_pay: '£0', type: 'full', },
    { id: 95, fee: '410', married_status: true, children: '2', income: '1800', remit: '380', they_pay: '£30', type: 'part', },
    { id: 96, fee: '410', married_status: false, children: '2', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 97, fee: '410', married_status: false, children: '3', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 98, fee: '410', married_status: false, children: '3', income: '1800', remit: '410', they_pay: '£0', type: 'full', },
    { id: 99, fee: '410', married_status: true, children: '3', income: '2000', remit: '400', they_pay: '£10', type: 'part', },
    { id: 100, fee: '410', married_status: false, children: '3', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 101, fee: '410', married_status: false, children: '4', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 102, fee: '410', married_status: false, children: '4', income: '2000', remit: '410', they_pay: '£0', type: 'full', },
    { id: 103, fee: '410', married_status: false, children: '4', income: '2100', remit: '395', they_pay: '£15', type: 'part', },
    { id: 104, fee: '410', married_status: false, children: '4', income: '3000', remit: '0', they_pay: '£410', type: 'none', },
    { id: 105, fee: '410', married_status: false, children: '5', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 106, fee: '410', married_status: false, children: '5', income: '2300', remit: '410', they_pay: '£0', type: 'full', },
    { id: 107, fee: '410', married_status: false, children: '5', income: '2400', remit: '365', they_pay: '£45', type: 'part', },
    { id: 108, fee: '410', married_status: false, children: '5', income: '3000', remit: '65', they_pay: '£345', type: 'part', },
    { id: 109, fee: '410', married_status: false, children: '6', income: '100', remit: '410', they_pay: '£0', type: 'full', },
    { id: 110, fee: '410', married_status: false, children: '6', income: '2500', remit: '410', they_pay: '£0', type: 'full', },
    { id: 111, fee: '410', married_status: false, children: '6', income: '2600', remit: '390', they_pay: '£20', type: 'part', },
    { id: 112, fee: '410', married_status: false, children: '6', income: '3000', remit: '190', they_pay: '£220', type: 'part', }
  ]

  beforeEach ->
    calc = new incomeCalculator()

  describe 'calculator', ->
    it 'will convert numbers to currency', ->
      expect(calc.formatCurrency(12)).toBe('£12')

    it 'will return a json object', ->
      expect(calc.calculate('a', 'b','c', 'd')).toEqual({ type: 'error', to_pay: '' })

    it 'will return correct values', ->
      expect(calc.calculate(410, false, 2, 2000).type).toEqual('part')

  describe 'scenario', ->
    runScenario(row) for row in seed_data
