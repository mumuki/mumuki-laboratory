module WithSubmissions
  extend ActiveSupport::Concern

  included do
    has_many :submissions, dependent: :restrict_with_error
  end

  def default_content_for(user)
    last_submission(user).try(&:content) || ''
  end

  def submissions_for(user)
    submissions.where(submitter_id: user.id)
  end

  def solved_by?(user)
    !!last_submission(user).try(&:passed?)
  end

  def submitted_by?(user)
    submissions_for(user).exists?
  end

  def last_submission(user)
    submissions_for(user).last
  end

  def status_for(user)
    last_submission(user).try { |it| it.status.group } || Status::Unknown
  end

  def last_submission_date_for(user)
    last_submission(user).try(&:created_at)
  end

  def submissions_count_for(user)
    submissions_for(user).count
  end
end
