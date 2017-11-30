module Views
  module Overview
    class Details
      include ActionView::Helpers::NumberHelper

      delegate(:form_name, :case_number, :deceased_name, :emergency_reason,  to: :detail)

      def initialize(application)
        @application = application
      end

      def all_fields
        [
          'fee', 'jurisdiction', 'date_received', 'form_name', 'case_number',
          'deceased_name', 'date_of_death', 'date_fee_paid', 'discretion_applied', 'emergency_reason'
        ]
      end

      def fee
        number_to_currency(detail.fee.round, precision: 0, unit: '£')
      end

      def jurisdiction
        detail.jurisdiction.name
      end

      [:date_received, :date_of_death, :date_fee_paid].each do |method|
        define_method(method) do
          format_date(detail.public_send(method))
        end
      end

      def discretion_applied
        return if detail.discretion_applied.nil?
        I18n.t("activemodel.attributes.forms/application/detail.discretion_applied_#{detail.discretion_applied}")
      end

      private

      def detail
        @application.detail
      end

      def format_date(date)
        date.to_s(:gov_uk_long) if date
      end
    end
  end
end
