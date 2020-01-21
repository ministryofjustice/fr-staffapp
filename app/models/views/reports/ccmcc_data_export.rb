module Views
  module Reports
    class CCMCCDataExport
      require 'csv'

      FIELDS = {
        reference: 'reference number',
        created_at: 'created at',
        fee: 'fee',
        outcome: 'outcome',
        amount_to_pay: 'applicant pays',
        decision_cost: 'departmental cost',
        name: 'processed by',
        ev_id: 'evidence check',
        check_type: 'evidence checked type',
        ccmcc_annotation: 'ccmcc annotations',
        refund: 'refund',
        state: 'application state'
      }.freeze

      HEADERS = FIELDS.values
      ATTRIBUTES = FIELDS.keys

      def initialize(start_date, end_date)
        @date_from = format_dates(start_date)
        @date_to = format_dates(end_date).end_of_day
      end

      def format_dates(date_attribute)
        DateTime.parse(date_attribute.values.join('/')).utc
      end

      def to_csv
        CSV.generate do |csv|
          csv << HEADERS

          data.each do |row|
            csv << ATTRIBUTES.map do |attr|
              if attr == :ev_id
                ev_check(row)
              else
                row.send(attr)
              end
            end
          end
        end
      end

      def total_count
        data.size
      end

      private

      def data
        @data ||= build_data
      end

      def build_data
        Application.left_outer_joins(:evidence_check).distinct.
          select('applications.reference', 'applications.created_at', 'details.fee',
                 'applications.outcome', 'applications.decision', 'applications.amount_to_pay', 'applications.decision_cost',
                 'users.name', 'evidence_checks.id as ev_id', 'evidence_checks.check_type', 'evidence_checks.ccmcc_annotation', 'details.refund',
                 'applications.state').
          joins(:office, :user, :detail).where(created_at: @date_from..@date_to).
          where("offices.entity_code = 'DH403'").where(application_type: 'income')
      end

      def ev_check(row)
        row.ev_id.blank? ? 'No' : 'Yes'
      end

    end
  end
end
