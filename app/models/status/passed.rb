module Status::Passed
  extend Status::Base

  def passed?
    true
  end

  def self.iconize
    {class: :success, type: :check}
  end
end
