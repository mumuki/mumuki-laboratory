require 'securerandom'

class ApiToken < ActiveRecord::Base

  after_initialize :set_value, if: :new_record?

  validates_presence_of :description

  private

  def set_value
    self.value = SecureRandom.hex
  end
end
