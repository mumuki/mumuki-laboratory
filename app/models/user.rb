class User < ActiveRecord::Base
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

  def self.omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.nickname
      user.email = auth.info.email
      user.token = auth.credentials.token
      auth.credentials.expires_at.try do |expiration|
        user.expires_at = Time.at(expiration)
      end
      user.save!
    end
  end

  def last_submission_date
    submissions.last.try(&:created_at)
  end

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
