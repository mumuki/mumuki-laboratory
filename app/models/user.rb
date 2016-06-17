class User < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name],
      using: {
          tsearch: {any_word: true}
      }
  }

  include WithSearch, WithOmniauth, WithToken, WithMetadata

  has_many :assignments, foreign_key: :submitter_id

  has_many :submitted_exercises, through: :assignments, class_name: 'Exercise', source: :exercise

  has_many :solved_exercises,
           -> { where('assignments.status' => Status::Passed.to_i) },
           through: :assignments,
           class_name: 'Exercise',
           source: :exercise

  belongs_to :last_exercise, class_name: 'Exercise'
  belongs_to :last_organization, class_name: 'Organization'

  has_one :last_guide, through: :last_exercise, source: :guide

  has_and_belongs_to_many :exams

  after_initialize :init

  def last_lesson
    last_guide.lesson
  end

  def last_submission_date
    assignments.last.try(&:updated_at)
  end

  def submissions_count
    assignments.pluck(:submissions_count).sum
  end

  def passed_submissions_count
    passed_assignments.count
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

  def passed_assignments
    assignments.where(status: Status::Passed.to_i)
  end

  def create_remember_me_token!
    self.remember_me_token ||= get_token
    self.save!
  end

  def social_id
    uid
  end

  def comments
    assignments.flat_map(&:comments)
  end

  def unread_comments
    comments.reject(&:read)
  end

  def visit!(organization)
    update!(last_organization: organization) if organization != last_organization
  end

  private

  def init
    self.image_url ||= "user_shape.png"
  end

end
