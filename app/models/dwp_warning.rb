class DwpWarning < ActiveRecord::Base
  before_create :only_one_record_allowed

  STATES = { online: 'online', offline: 'offline', default_checker: 'default_checker' }.freeze

  def self.use_default_check?
    return true if last.blank?

    last.check_state == STATES[:default_checker]
  end

  def self.state
    return if last.blank?
    last.check_state
  end

  private

  def only_one_record_allowed
    if DwpWarning.count >= 1
      errors.add(:base, 'Only one DwpWarning is allowed')
      return false
    end

    true
  end
end
