module WithSubmissions
  extend ActiveSupport::Concern

  included do
    has_many :submissions
  end

  def default_content_for(user)
    last_submission(user).try(&:content) || ''
  end

  def submissions_for(user)
    submissions.where(submitter_id: user.id)
  end

  def has_submissions_for?(user)
    submissions_for(user).any?
  end

  def solved_by?(user)
    submissions_for(user).where("status = ?", Submission.statuses[:passed]).exists?
  end

  def submitted_by?(user)
    submissions_for(user).exists?
  end

  def last_submission(user)
    submissions_for(user).last
  end
end
