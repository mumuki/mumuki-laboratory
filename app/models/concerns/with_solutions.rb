
module WithSolutions
  extend ActiveSupport::Concern

  included do
    has_many :solutions, dependent: :destroy
  end

  def default_content_for(user)
    solution_for(user).try(&:content) || ''
  end

  def solution_for(user)
    solutions.find_by(submitter_id: user.id)
  end

  def solved_by?(user)
    !!solution_for(user).try(&:passed?)
  end

  def submitted_by?(user)
    solution_for(user).present?
  end

  def status_for(user)
    solution_for(user).try(&:status) || Status::Unknown
  end

  def last_submission_date_for(user)
    solution_for(user).try(&:created_at)
  end

  def submissions_count_for(user)
    solution_for(user).try(&:submissions_count) || 0
  end

  def submit_solution(user, attributes={})
    solution_with(user, attributes).tap { |it| it.save! }
  end

  private

  def solution_with(user, attributes)
    if submitted_by?(user)
      solution_for(user).tap { |it| it.assign_attributes attributes }
    else
      user.solutions.build({exercise: self}.merge(attributes))
    end
  end
end
