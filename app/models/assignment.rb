class Assignment < ApplicationRecord
  include Contextualization
  include WithMessages

  belongs_to :exercise
  has_one :guide, through: :exercise
  has_many :messages, -> { order(date: :desc) }, foreign_key: :submission_id, primary_key: :submission_id

  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  delegate :language, :name, to: :exercise

  alias_attribute :status, :submission_status

  scope :by_exercise_ids, -> (exercise_ids) {
    where(exercise_id: exercise_ids) if exercise_ids
  }

  scope :by_usernames, -> (usernames) {
    joins(:submitter).where('users.name' => usernames) if usernames
  }

  def evaluate_manually!(teacher_evaluation)
    update! status: teacher_evaluation[:status], manual_evaluation_comment: teacher_evaluation[:manual_evaluation]
  end

  def persist_submission!(submission)
    transaction do
      messages.destroy_all
      update! submission_id: submission.id
      update_submissions_count!
      update_last_submission!
    end
  end

  def extension
    exercise.language.extension
  end

  def notify!
    Mumukit::Nuntius.notify! 'submissions', as_platform_json unless Organization.current.silent?
  end

  def notify_to_accessible_organizations!
    submitter.accessible_organizations.each do |organization|
      organization.switch!
      notify!
    end
  end

  def self.evaluate_manually!(teacher_evaluation)
    Assignment.find_by(submission_id: teacher_evaluation[:submission_id])&.evaluate_manually! teacher_evaluation
  end

  def content=(content)
    if content.present?
      self.solution = exercise.single_choice? ? exercise.choices.index(content) : content
    end
  end

  def test
    exercise.test_for submitter
  end

  def extra
    exercise.extra_for submitter
  end

  def run_update!
    running!
    begin
      update! yield
    rescue => e
      errored! e.message
      raise e
    end
  end

  def passed!
    update! submission_status: :passed
  end

  def running!
    update! submission_status: :running,
            result: nil,
            test_results: nil,
            expectation_results: [],
            manual_evaluation_comment: nil
  end

  def errored!(message)
    update! result: message, submission_status: :errored
  end

  %w(query try).each do |key|
    name = "run_#{key}!"
    define_method(name) { |params| exercise.send name, params.merge(extra: extra) }
  end

  def run_tests!(params)
    exercise.run_tests! params.merge(extra: extra, test: test)
  end

  def as_platform_json
    navigable_parent = exercise.navigable_parent
    as_json(except: [:exercise_id, :submission_id, :id, :submitter_id, :solution, :created_at, :updated_at, :submission_status],
              include: {
                guide: {
                  only: [:slug, :name],
                  include: {
                    lesson: {only: [:number]},
                    language: {only: [:name]}},
                },
                exercise: {only: [:name, :number]},
                submitter: {only: [:email, :image_url, :social_id, :uid], methods: [:name]}}).
      deep_merge(
        'organization' => Organization.current.name,
        'sid' => submission_id,
        'created_at' => updated_at,
        'content' => solution,
        'status' => submission_status,
        'exercise' => {
          'eid' => exercise.bibliotheca_id
        },
        'guide' => {'parent' => {
          'type' => navigable_parent.class.to_s,
          'name' => navigable_parent.name,
          'position' => navigable_parent.try(:number),
          'chapter' => guide.chapter.as_json(only: [:id], methods: [:name])
        }})
  end

  def tips
    @tips ||= exercise.assist_with(self)
  end

  def increment_attemps!
    self.attemps_count += 1 unless passed?
  end

  private

  def update_submissions_count!
    self.class.connection.execute(
      "update public.exercises
         set submissions_count = submissions_count + 1
        where id = #{exercise.id}")
    self.class.connection.execute(
      "update public.assignments
         set submissions_count = submissions_count + 1
        where id = #{id}")
    exercise.reload
  end

  def update_last_submission!
    submitter.update!(last_submission_date: DateTime.now, last_exercise: exercise)
  end

end
