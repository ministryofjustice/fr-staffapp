if ENV['ENV'] == 'trial'
  namespace :trial_migration do
    desc 'Delete applications for an office'
    task :delete_office_applications, [:office_id] => :environment do |_, args|
      office = Office.find(args[:office_id])
      count = 0

      ActiveRecord::Base.transaction do
        office.applications.each do |application|
          application.applicant.delete
          application.detail.delete

          application.benefit_checks.delete_all unless application.benefit_checks.empty?
          application.evidence_check.delete if application.evidence_check
          application.part_payment.delete if application.part_payment
          application.benefit_override.delete if application.benefit_override

          application.delete
          count += 1
        end
      end

      puts "Deleted: #{count}"
    end

    desc 'Delete applications created by a user'
    task :delete_user_applications, [:user_id] => :environment do |_, args|
      user = User.with_deleted.find(args[:user_id])
      count = 0

      ActiveRecord::Base.transaction do
        Application.where(user: user).each do |application|
          application.applicant.delete
          application.detail.delete

          application.benefit_checks.delete_all unless application.benefit_checks.empty?
          application.evidence_check.delete if application.evidence_check
          application.part_payment.delete if application.part_payment
          application.benefit_override.delete if application.benefit_override

          application.delete
          count += 1
        end
      end

      puts "Deleted: #{count}"
    end

    desc 'Delete users with email domain'
    task :delete_users, [:user_ids] => :environment do |_, args|
      user_ids = args[:user_ids].split(' ')
      count = 0

      ActiveRecord::Base.transaction do
        user_ids.each do |user_id|
          user = User.find(user_id)

          feedbacks = Feedback.where(user: user)
          feedbacks.delete_all unless feedbacks.empty?

          user.really_destroy!
          count += 1
        end
      end

      puts "Deleted: #{count}"
    end

    desc 'Delete office'
    task :delete_office, [:office_id] => :environment do |_, args|
      office = Office.find(args[:office_id])

      ActiveRecord::Base.transaction do
        business_entities = BusinessEntity.where(office: office)
        office_jurisdictions = OfficeJurisdiction.where(office: office)
        feedbacks = Feedback.where(office: office)

        business_entities.delete_all unless business_entities.empty?
        office_jurisdictions.delete_all unless office_jurisdictions.empty?
        feedbacks.delete_all unless feedbacks.empty?

        office.delete
      end
    end

    desc 'Increment primary keys to avoid intersection for merging'
    task :increment_primary_keys, [:increment] => :environment do |_, args|
      increment = args[:increment]

      tables = %w[applicants applications benefit_checks benefit_overrides
                  business_entities details evidence_checks feedbacks jurisdictions offices
                  online_applications part_payments users]

      ActiveRecord::Base.transaction do
        connection = ActiveRecord::Base.connection

        tables.each do |table|
          connection.execute("UPDATE #{table} SET id = id + #{increment}")
        end

        # This is a hack as foreign key referencing primary key in the same table
        # had to be lifted for the migration
        connection.execute("UPDATE users SET invited_by_id = invited_by_id + #{increment}")
      end
    end

    desc 'Update primary keys auto increment to the latest primary keys'
    task update_auto_increment_to_latest: :environment do
      tables = %w[applicants applications benefit_checks benefit_overrides
                  business_entities details evidence_checks feedbacks jurisdictions offices
                  online_applications part_payments users]

      ActiveRecord::Base.transaction do
        connection = ActiveRecord::Base.connection

        tables.each do |table|
          next_val_sql = "COALESCE((SELECT MAX(id)+1 FROM #{table}), 1)"
          sql = "SELECT setval('#{table}_id_seq', #{next_val_sql}, false);"
          connection.execute(sql)
        end
      end
    end

    desc 'Change user email'
    task :change_user_email, [:from, :to] => :environment do |_, args|
      from = args[:from]
      to = args[:to]

      user = User.find_by(email: from)
      user.update(email: to)
    end

    desc 'Change user name'
    task :change_user_name, [:user_id, :name] => :environment do |_, args|
      user_id = args[:user_id]
      name = args[:name]

      user = User.find(user_id)
      user.update(name: name)
    end

    desc 'Change user office'
    task :change_user_office, [:user_id, :office_id] => :environment do |_, args|
      user_id = args[:user_id]
      office_id = args[:office_id]

      user = User.find(user_id)
      user.update(office_id: office_id)
    end
  end
end

if ENV['ENV'] == 'production'
  namespace :production_migration do
    desc 'Update primary keys auto increment to a specific ID'
    task :update_auto_increment_to_specified, [:new_id] => :environment do |_, args|
      new_id = args[:new_id]

      tables = %w[applicants applications benefit_checks benefit_overrides
                  business_entities details evidence_checks feedbacks jurisdictions offices
                  online_applications part_payments users]

      ActiveRecord::Base.transaction do
        connection = ActiveRecord::Base.connection

        tables.each do |table|
          connection.execute("SELECT setval('#{table}_id_seq', #{new_id}, true);")
        end
      end
    end
  end
end
