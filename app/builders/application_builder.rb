class ApplicationBuilder

  attr_reader :application, :reference

  def initialize(current_user)
    @user = current_user
  end

  def build
    Application.new(
      office_id: @user.office_id,
      user_id: @user.id,
      applicant: build_applicant,
      detail: build_details
    )
  end

  def build_from(online_application)
    attributes = {
      office_id: @user.office_id,
      user_id: @user.id,
      online_application: online_application,
      applicant: Applicant.new(online_applicant_attributes(online_application)),
      detail: Detail.new(online_detail_attributes(online_application))
    }.merge(online_application_attributes(online_application))

    Application.new(attributes)
  end

  private

  def build_applicant
    Applicant.new
  end

  def build_details
    Detail.new(jurisdiction_id: @user.jurisdiction_id)
  end

  def online_application_attributes(online_application)
    fields = %i[threshold_exceeded benefits income reference]
    prepare_attributes(fields, online_application).merge(dependent_attributes(online_application))
  end

  def dependent_attributes(online_application)
    {}.tap do |attributes|
      if online_application.children.present?
        attributes[:dependents] = online_application.children > 0
        attributes[:children] = online_application.children
      end
    end
  end

  def online_applicant_attributes(online_application)
    fields = %i[title first_name last_name date_of_birth ni_number married]
    prepare_attributes(fields, online_application)
  end

  def online_detail_attributes(online_application)
    fields = %i[fee jurisdiction date_received form_name case_number probate deceased_name
                date_of_death refund date_fee_paid emergency_reason]
    prepare_attributes(fields, online_application)
  end

  def prepare_attributes(fields, online_application)
    Hash[fields.map { |field| [field, online_application.send(field)] }]
  end
end
