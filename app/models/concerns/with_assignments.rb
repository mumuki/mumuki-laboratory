module WithAssignments
  extend ActiveSupport::Concern

  included do
    has_many :assignments, dependent: :destroy
  end

  def current_content_for(user)
    assignment_for(user).try(&:solution) ||
      default_content_for(user)
  end

  def default_content_for(user)
    (default_content || '').gsub('/*...previousContent...*/') { previous.current_content_for(user) }
  end

  def messages_for(user)
    assignment_for(user).try(&:messages) || []
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
    assignment_for(user).defaulting(Status::Unknown, &:status) if user
  end

  def last_submission_date_for(user)
    assignment_for(user).try(&:updated_at)
  end

  def last_submission_id_for(user)
    assignment_for(user)&.submission_id
  end

  def submissions_count_for(user)
    assignment_for(user).try(&:submissions_count) || 0
  end

  def clean_for?(user)
    submissions_count_for(user).zero?
  end

  def find_or_init_assignment_for(user)
    if assigned_to?(user)
      assignment_for(user)
    else
      user.assignments.build(exercise: self)
    end
  end
end
