module Status::Passed
  extend Status::Base

  def self.passed?
    true
  end

  def self.should_retry?
    false
  end

  def self.iconize
    {class: :success, type: :check}
  end
end
