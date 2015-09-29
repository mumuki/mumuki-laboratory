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


  def self.earned_points(max_points, submissions_count)
    Status::Passed.earned_points(max_points, submissions_count) / 2
  end
end
