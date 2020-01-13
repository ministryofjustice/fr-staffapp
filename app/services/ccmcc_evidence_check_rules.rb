class CCMCCEvidenceCheckRules
  OFFICE_CODE = 'DH403'.freeze
  FIVE_K_RULE_FREQUENCY = 1
  FIVE_K_RULE_ANNOTATION = 'over 5 thousand'.freeze
  ONE_TO_5_K_RULE_FREQUENCY = 4
  ONE_TO_5_K_RULE_ANNOTATION = 'between 1 and 5 thousand'.freeze
  ONE_TO_ONE_THOUSAND_REFUND_RULE_FREQUENCY = 4
  ONE_TO_ONE_THOUSAND_REFUND_RULE_ANNOTATION = 'between 100 and 999 refund'.freeze
  ONE_TO_ONE_THOUSAND_RULE_FREQUENCY = 10
  ONE_TO_ONE_THOUSAND_RULE_ANNOTATION = 'between 100 and 999 non refund'.freeze
  QUERY_ALL = :all
  QUERY_REFUND = :refund

  attr_reader :frequency, :check_type, :query_type

  def initialize(application)
    @application = application
  end

  def rule_applies?
    return false unless same_office?
    fee_range_applies?
  end

  def fee_range_applies?
    case @application.detail.fee
    when 5000..Float::INFINITY
      over_five_thousand
    when 1000..4999
      between_one_and_five_thousands
    when 100..999
      between_one_hundred_and_ninehundredninetynine
    else
      false
    end
  end

  private

  def same_office?
    @application.office.try(:entity_code) == OFFICE_CODE
  end

  def over_five_thousand
    @frequency = FIVE_K_RULE_FREQUENCY
    @check_type = FIVE_K_RULE_ANNOTATION
    @query_type = QUERY_ALL
    true
  end

  def between_one_and_five_thousands
    return false if @application.detail.refund
    @frequency = ONE_TO_5_K_RULE_FREQUENCY
    @check_type = ONE_TO_5_K_RULE_ANNOTATION
    true
  end

  def between_one_hundred_and_ninehundredninetynine
    if @application.detail.refund
      @query_type = QUERY_REFUND
      @frequency = ONE_TO_ONE_THOUSAND_REFUND_RULE_FREQUENCY
      @check_type = ONE_TO_ONE_THOUSAND_REFUND_RULE_ANNOTATION
    else
      @frequency = ONE_TO_ONE_THOUSAND_RULE_FREQUENCY
      @check_type = ONE_TO_ONE_THOUSAND_RULE_ANNOTATION
    end
    true
  end
end