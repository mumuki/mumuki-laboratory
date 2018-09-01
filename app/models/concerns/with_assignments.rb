module WithAssignments
  extend ActiveSupport::Concern

  # TODO we must avoid _for(user) methods when they
  # are hidden the assignment object, since an assignment already encapsulates
  # the exercise-user pair, and many times they impose a performance hit,
  # since in the normal scenario the assignment object already exists

  included do
    has_many :assignments, dependent: :destroy
  end

  def messages_for(user)
    assignment_for(user).messages
  end

  def has_messages_for?(user)
    messages_for(user).present?
  end

  def find_assignment_for(user)
    assignments.find_by(submitter: user)
  end

  def status_for(user)
    assignment_for(user).status if user
  end

  def assignment_for(user)
    find_assignment_for(user) || user.assignments.build(exercise: self)
  end
end
