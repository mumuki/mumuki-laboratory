module Mumuki::Laboratory::Status::PassedWithWarnings
  extend Mumuki::Laboratory::Status::Base

  def self.passed?
    true
  end

  def self.iconize
    {class: :warning, type: 'exclamation-circle'}
  end
end
