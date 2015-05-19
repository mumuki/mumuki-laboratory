require 'securerandom'

class ApiToken < ActiveRecord::Base

  after_initialize :set_value, if: :new_record?

  validates_presence_of :description, :client_id, :client_secret

  private

  def set_value
    self.client_id = SecureRandom.base64(8)
    self.client_secret = SecureRandom.base64(32)
  end
end
