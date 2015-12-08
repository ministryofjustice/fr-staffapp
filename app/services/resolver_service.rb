class ResolverService
  class UndefinedOutcome < StandardError; end
  class NotRemovable < StandardError; end

  def initialize(object, user)
    @calling_object = object
    @user = user
  end

  def complete
    check_outcome!
    send("complete_#{derive_object(@calling_object)}", @calling_object)
  end

  def return
    ActiveRecord::Base.transaction do
      @calling_object.update({ outcome: 'return' }.merge(completed_attributes))
      @calling_object.application.update(decided_attributes(@calling_object))
    end
  end

  def remove
    raise NotRemovable unless @calling_object.processed? && @calling_object.removed_reason.present?
    @calling_object.removed!
  end

  private

  def check_outcome!
    raise UndefinedOutcome unless @calling_object.outcome.present?
  end

  def completed_attributes
    {
      completed_at: Time.zone.now,
      completed_by: @user
    }
  end

  def decided_attributes(source)
    {
      decision: lookup_decision(source.outcome),
      decision_type: derive_object(source),
      state: :processed
    }
  end

  def complete_application(application)
    attributes = completed_attributes.tap do |attrs|
      if decide_evidence_check(application)
        attrs[:state] = :waiting_for_evidence
      elsif decide_part_payment(application)
        attrs[:state] = :waiting_for_part_payment
      else
        attrs.merge!(decided_attributes(application))
      end
    end

    application.update(attributes)
  end

  def complete_evidence_check(evidence_check)
    evidence_check.update(completed_attributes)

    application_attributes = {}.tap do |attrs|
      if decide_part_payment(evidence_check)
        attrs[:state] = :waiting_for_part_payment
      else
        attrs.merge!(decided_attributes(evidence_check))
      end
    end
    evidence_check.application.update(application_attributes)
  end

  def complete_part_payment(part_payment)
    part_payment.update(completed_attributes)
    part_payment.application.update(decided_attributes(part_payment))
  end

  def derive_object(object)
    object.class.name.underscore
  end

  def lookup_decision(outcome)
    { 'full' => 'full',
      'part' => 'part',
      'none' => 'none',
      'return' => 'none' }[outcome]
  end

  def evidence_check_and_payment
    decide_evidence_check(@calling_object)
    decide_part_payment(@calling_object)
  end

  def decide_part_payment(application)
    PartPaymentBuilder.new(application, Settings.part_payment.expires_in_days).decide!
  end

  def decide_evidence_check(application)
    EvidenceCheckSelector.new(application, Settings.evidence_check.expires_in_days).decide!
  end
end
