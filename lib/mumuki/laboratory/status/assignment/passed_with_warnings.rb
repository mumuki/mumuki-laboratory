module Mumuki::Laboratory::Status::Assignment::PassedWithWarnings
  extend Mumuki::Laboratory::Status::Assignment

  def self.passed?
    true
  end

  def self.iconize
    {class: :warning, type: 'exclamation-circle'}
  end
end
