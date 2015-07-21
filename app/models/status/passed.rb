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

  def self.earned_points(max_points, submissions_count)
    if submissions_count <= 2
      max_points
    elsif submissions_count <= 11
      max_points - (submissions_count - 2) * max_points.div(10)
    else
      1
    end
  end
end
