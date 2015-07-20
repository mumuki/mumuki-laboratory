module Status::PassedWithWarnings
  extend Status::Base

  def self.passed?
    true
  end

  def self.should_retry?
    true
  end

  def self.iconize
    {class: :warning, type: :exclamation}
  end
end
