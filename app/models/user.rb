class User < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name],
      using: {
          tsearch: {any_word: true}
      }
  }

  include WithSearch
  include WithOmniauth

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

  def submissions_count
    submissions.count
  end

  def passed_submissions_count
    submissions.where(status: Submission.passed_status).count
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
