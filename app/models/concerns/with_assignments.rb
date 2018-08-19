module WithAssignments
  extend ActiveSupport::Concern

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

  def interpolate_for(user, field)
    language.interpolate(field, user.interpolations, lambda { |content| replace_content_reference(user, content) })
  end

  def default_content_for(user)
    interpolate_for user, default_content || ''
  end

  def extra_for(user)
    interpolate_for user, extra
  end

  def test_for(user)
    test && interpolate_for(user, test)
  end

  def replace_content_reference(user, interpolee)
    case interpolee
      when /previousContent|previousSolution/
        previous.current_content_for(user)
      when /(solution|content)\[(-?\d*)\]/
        sibling_at($2.to_i).current_content_for(user)
    end
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
    assignment_for(user).defaulting(Mumuki::Laboratory::Status::Submission::Unknown, &:status) if user
  end

  def find_or_init_assignment_for(user)
    assignment_for(user) || user.assignments.build(exercise: self)
  end
end
