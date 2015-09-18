class User < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name],
      using: {
          tsearch: {any_word: true}
      }
  }

  include WithSearch, WithOmniauth, WithGitAccess, WithToken

  has_many :solutions, foreign_key: :submitter_id
  has_many :exercises, foreign_key: :author_id
  has_many :guides, foreign_key: :author_id

  has_many :submitted_exercises, through: :solutions, class_name: 'Exercise', source: :exercise

  has_many :submitted_guides, -> { uniq }, through: :submitted_exercises, class_name: 'Guide', source: :guide

  has_many :submitted_paths, -> { uniq }, through: :submitted_guides, class_name: 'Path', source: :path

  has_many :solved_exercises,
           -> { where('solutions.status' => Status::Passed.to_i) },
           through: :solutions,
           class_name: 'Exercise',
           source: :exercise

  belongs_to :last_exercise, class_name: 'Exercise'
  has_one :last_guide, through: :last_exercise, source: :guide

  after_create :notify_registration!

  def last_submission_date
    solutions.last.try(&:created_at)
  end

  def submissions_count
    solutions.pluck(:submissions_count).sum
  end

  def passed_submissions_count
    passed_solutions.count
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

  def passed_solutions
    solutions.where(status: Status::Passed.to_i)
  end

  def create_remember_me_token!
    self.remember_me_token ||= get_token
    self.save!
  end

  private

  def notify_registration!
    EventSubscriber.notify_async!(Event::Registration.new(self))
  end

end
