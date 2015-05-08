require 'securerandom'

class ApiToken < ActiveRecord::Base

  before_create :set_value

  validates_presence_of :description

  private

  def set_value
    self.value = SecureRandom.hex
  end
end
