module Views
  module Overview
    class Application

      include ActionView::Helpers::NumberHelper

      delegate(:amount_to_pay, :reference, to: :@application)

      def initialize(application)
        @application = application
      end

      def all_fields
        %w[benefits dependants number_of_children total_monthly_income savings]
      end

      def benefits_result
        if type.eql?('benefit')
          return format_locale('passed_by_override') if @application.decision_override.present?
          return format_locale('passed_with_evidence') if benefit_override?
          format_locale(benefit_result) if @application.last_benefit_check
        end
      end

      def income_result
        format_locale(%w[full part].include?(result).to_s)
      end

      def savings_result
        format_locale(@application.saving.passed?.to_s)
      end

      def benefits
        convert_to_boolean(@application.benefits?)
      end

      def type
        @application.application_type
      end

      def result
        @application.outcome
      end

      def total_monthly_income
        @application.income ? format_currency(@application.income.round) : format_threshold_income
      end

      def number_of_children
        @application.children
      end

      def return_type
        {
          'evidence_check' => 'evidence',
          'part_payment' => 'payment'
        }[@application.decision_type] || nil
      end

      def amount_to_pay
        if evidence_or_application.amount_to_pay.present?
          "£#{evidence_or_application.amount_to_pay.round}"
        end
      end

      private

      def format_threshold_income
        if @application.income_min_threshold_exceeded == false
          I18n.t('income.below_threshold', threshold: format_currency(thresholds.min_threshold))
        elsif @application.income_max_threshold_exceeded
          I18n.t('income.above_threshold', threshold: format_currency(thresholds.max_threshold))
        end
      end

      def thresholds
        IncomeThresholds.new(@application.applicant.married, @application.children)
      end

      def benefit_result
        @application.last_benefit_check.dwp_result.eql?('Yes').to_s
      end

      def benefit_override?
        BenefitOverride.exists?(application_id: @application.id, correct: true)
      end

      def evidence_or_application
        @application.evidence_check || @application
      end

      def format_locale(suffix)
        I18n.t(suffix, scope: 'activemodel.attributes.forms/application/summary')
      end

      def format_currency(amount)
        number_to_currency(amount, precision: 0, unit: '£')
      end

      def convert_to_boolean(input)
        I18n.t("convert_boolean.#{input.present? ? input : 'false'}")
      end
    end
  end
end