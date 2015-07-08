module Status::PassedWithWarnings
  extend Status::Base

  def passed?
    true
  end

  def self.iconize
    {class: :warning, type: :exclamation}
  end
end
