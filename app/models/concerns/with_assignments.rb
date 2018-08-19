module WithAssignments
  extend ActiveSupport::Concern

  # TODO we must avoid _for(user) methods when they
  # are hidden the assignment object, since an assignment already encapsulates
  # the exercise-user pair, and many times they impose a performance hit,
  # since in the normal scenario the assignment object already exists

  included do
    has_many :assignments, dependent: :destroy
  end

  def current_content_for(user)
    assignment_for(user)&.solution || default_content_for(user)
  end

  def files_for(user)
    language
      .directives_sections
      .split_sections(current_content_for user)
      .map { |name, content| Mumuki::Laboratory::File.new name, content }
  end

  def default_content_for(user)
    language.interpolate_references_for self, user, default_content || ''
  end

  def extra_for(user)
    extra && language.interpolate_references_for(self, user, extra)
  end

  def test_for(user)
    test && language.interpolate_references_for(self, user, test)
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

  def status_for(user)
    assignment_for(user).defaulting(Mumuki::Laboratory::Status::Submission::Pending, &:status) if user
  end

  def find_or_init_assignment_for(user)
    assignment_for(user) || user.assignments.build(exercise: self)
  end
end
