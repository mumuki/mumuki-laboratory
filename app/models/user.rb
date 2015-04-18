class User < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name],
      using: {
          tsearch: {any_word: true}
      }
  }

  include WithSearch, WithOmniauth, WithOctokit, WithFollowers

  has_many :submissions, foreign_key: :submitter_id
  has_many :exercises, foreign_key: :author_id
  has_many :guides, foreign_key: :author_id

  has_many :submitted_exercises,
           -> { uniq },
           through: :submissions,
           class_name: 'Exercise',
           source: :exercise

  has_many :solved_exercises,
           -> { where('submissions.status' => Submission.passed_status).uniq },
           through: :submissions,
           class_name: 'Exercise',
           source: :exercise

  def last_submission_date
    submissions.last.try(&:created_at)
  end

  def submissions_count
    submissions.count
  end

  def has_submissions?
    !submissions.empty?
  end

  def passed_submissions_count
    submissions.where(status: Submission.passed_status).count
  end

  def passed_submissions_count_per_week
    submissions.where(status: Submission.passed_status).group_by_week(:created_at).count
  end

  def failed_submissions_count_per_week
    submissions.where(status: Submission.failed_status).group_by_week(:created_at).count
  end

  def submitted_exercises_count
    submitted_exercises.count
  end

  def solved_exercises_count
    solved_exercises.count
  end

  def submissions_success_rate
    "#{passed_submissions_count}/#{submissions_count}"
  end

  def exercises_success_rate
    "#{solved_exercises_count}/#{submitted_exercises_count}"
  end

end
