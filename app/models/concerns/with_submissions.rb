module WithSubmissions
  extend ActiveSupport::Concern

  included do
    has_many :submissions, dependent: :restrict_with_error
  end

  def submissions_for(user)
    submissions.where(submitter_id: user.id)
  end

  def submitted_by?(user)
    submissions_for(user).exists?
  end

  def submissions_count_for(user)
    submissions_for(user).count
  end
end


