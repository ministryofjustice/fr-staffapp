
Jurisdiction.create([{ name: 'County', abbr: nil },
{ name: 'Family', abbr: nil },
{ name: 'High', abbr: nil },
{ name: 'Insolvency', abbr: nil },
{ name: 'Magistrates', abbr: nil },
{ name: 'Probate', abbr: nil },
{ name: 'Employment', abbr: nil },
{ name: 'Gambling', abbr: nil },
{ name: 'Gender recognition', abbr: nil },
{ name: 'Immigration (first-tier)', abbr: nil },
{ name: 'Immigration (upper)', abbr: nil },
{ name: 'Property', abbr: nil }])

Office.create(name: 'Digital', entity_code: 'MA105', jurisdiction_ids: [1])
Office.create(name: 'Bristol', entity_code: 'DB402', jurisdiction_ids: [1])

OfficeJurisdiction.all.each do |oj|
  BusinessEntity.create(
      office: oj.office,
      jurisdiction: oj.jurisdiction,
      be_code: oj.office.entity_code,
      name: "#{oj.office.name} - #{oj.jurisdiction.name}",
      valid_from: Time.zone.now
  )
end

unless ENV=='production'
  User.create([{
                name: 'Admin',
                email: 'fee-remission@digital.justice.gov.uk',
                password: '123456789',
                role: 'admin',
                office: Office.find_by(name: 'Digital')
              },
              {
                name: 'Mi',
                email: 'digital.mi@digital.justice.gov.uk',
                password: '123456789',
                role: 'mi',
                office: Office.find_by(name: 'Digital')
              },
              {
                name: 'User',
                email: 'bristol.user@hmcts.gsi.gov.uk',
                password: '987654321',
                role: 'user',
                office: Office.find_by(name: 'Bristol')
              },
              {
                name: 'Manager',
                email: 'bristol.manager@hmcts.gsi.gov.uk',
                password: '987654321',
                role: 'manager',
                office: Office.find_by(name: 'Bristol')
              }
              ])
end
