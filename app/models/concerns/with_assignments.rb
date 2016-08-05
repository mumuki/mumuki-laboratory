module WithAssignments
  extend ActiveSupport::Concern

  included do
    has_many :assignments, dependent: :destroy
  end

  def default_content_for(user)
    assignment_for(user).try(&:solution) ||
      interpolated_default_content_for(user)
  end

  def interpolated_default_content_for(user)
    (default_content || '').gsub('/*...previousContent...*/') { previous(user).default_content_for(user) }
  end

  def comments_for(user)
    assignment_for(user).try(&:comments) || []
  end

  def assignment_for(user)
    assignments.find_by(submitter_id: user.id)
  end

  def solved_by?(user)
    !!assignment_for(user).try(&:passed?)
  end

  def assigned_to?(user)
    assignment_for(user).present?
  end

  def status_for(user)
    assignment_for(user).try(&:status) || Status::Unknown
  end

  def last_submission_date_for(user)
    assignment_for(user).try(&:updated_at)
  end

  def submissions_count_for(user)
    assignment_for(user).try(&:submissions_count) || 0
  end

  def find_or_init_assignment_for(user)
    if assigned_to?(user)
      assignment_for(user)
    else
      user.assignments.build(exercise: self)
    end
  end
end
