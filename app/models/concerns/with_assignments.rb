module WithAssignments
  extend ActiveSupport::Concern

  included do
    has_many :assignments, dependent: :destroy
  end

  def current_content_for(user)
    assignment_for(user).try(&:solution) ||
      default_content_for(user)
  end

  def files_content_for(user)
    language.new_sections_directive.split_sections(assignment_for(user)&.solution || default_content_for(user))
      .except('content')
  end

  def default_content_for(user)
    (default_content || '')
      .gsub(/\/\*\.\.\.(previousContent|previousSolution)\.\.\.\*\//) { previous.current_content_for(user) }
      .gsub(/\/\*\.\.\.(solution|content)\[(-?\d*)\]\.\.\.\*\//) { sibling_at($2.to_i).current_content_for(user) }
  end

  def messages_for(user)
    assignment_for(user)&.messages || []
  end

  def has_messages_for?(user)
    messages_for(user).present?
  end

  def assignment_for(user)
    assignments.find_by(submitter: user)
  end

  def solved_by?(user)
    !!assignment_for(user).try(&:passed?)
  end

  def assigned_to?(user)
    assignments.exists?(submitter: user)
  end

  def status_for(user)
    assignment_for(user).defaulting(Status::Unknown, &:status) if user
  end

  def last_submission_date_for(user)
    assignment_for(user).try(&:updated_at)
  end

  def submissions_count_for(user)
    assignment_for(user).try(&:submissions_count) || 0
  end

  def find_or_init_assignment_for(user)
    assignment_for(user) || user.assignments.build(exercise: self)
  end
end
