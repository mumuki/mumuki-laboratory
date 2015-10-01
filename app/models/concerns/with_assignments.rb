module WithAssignments
  extend ActiveSupport::Concern

  included do
    has_many :assignments, dependent: :destroy
  end

  def previous_solution_for(user)
    assignment_for(user).try(&:solution) || ''
  end

  def assignment_for(user)
    assignments.find_by(submitter_id: user.id)
  end

  def solved_by?(user)
    !!assignment_for(user).try(&:passed?)
  end

  def submitted_by?(user)
    assignment_for(user).present?
  end

  def status_for(user)
    assignment_for(user).try(&:status) || Status::Unknown
  end

  def last_submission_date_for(user)
    assignment_for(user).try(&:created_at)
  end

  def submissions_count_for(user)
    assignment_for(user).try(&:submissions_count) || 0
  end

  def submit_solution(user, solution={})
    transaction do
      assignment_with(user, solution: solution[:content]).tap { |it| it.submit! }
    end
  end

  private

  def assignment_with(user, attributes)
    if submitted_by?(user)
      assignment_for(user).tap { |it| it.assign_attributes attributes }
    else
      user.assignments.build({exercise: self}.merge(attributes))
    end
  end
end
