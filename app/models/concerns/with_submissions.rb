module WithSubmissions
  extend ActiveSupport::Concern

  included do
    has_many :submissions, dependent: :restrict_with_error
  end

  def default_content_for(user)
    progress_for(user).content
  end

  def submissions_for(user)
    submissions.where(submitter_id: user.id)
  end

  def solved_by?(user)
    progress_for(user).solved?
  end

  def submitted_by?(user)
    submissions_for(user).exists?
  end

  def last_submission(user)
    progress_for(user).last_submission
  end

  def status_for(user)
    progress_for(user).status
  end

  def last_submission_date_for(user)
    progress_for(user).last_submission_date
  end

  def submissions_count_for(user)
    submissions_for(user).count
  end

  def progress_for(user)
    user.exercise_progress_for(self)
  end
end


