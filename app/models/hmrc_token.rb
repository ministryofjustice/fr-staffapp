class HmrcToken < ActiveRecord::Base
  include SimpleEncryptable

  before_create :only_one_record_allowed
  attr_encryptable :access_token, secret: ENV['HMRC_SECRET'], salt: ENV['HMRC_CLIENT_ID']

  def expired?
    return true if expires_in.blank?
    expires_in < Time.zone.now
  end

  private

  def only_one_record_allowed
    if HmrcToken.count >= 1
      errors.add(:base, 'Only one HmrcToken record is allowed')
      return false
    end

    true
  end
end
