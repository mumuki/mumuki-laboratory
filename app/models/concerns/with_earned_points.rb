module WithEarnedPoints
  extend ActiveSupport::Concern

  included do
    delegate :max_points, to: :exercise
  end

  def earned_points
    status.earned_points(max_points, exercise.submissions_for(submitter).count)
  end
end
