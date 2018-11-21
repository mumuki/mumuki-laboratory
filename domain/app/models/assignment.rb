class Assignment < ApplicationRecord
  include Contextualization
  include WithMessages

  markdown_on :extra_preview

  belongs_to :exercise
  has_one :guide, through: :exercise
  has_many :messages, -> { where.not(submission_id: nil).order(date: :desc) }, foreign_key: :submission_id, primary_key: :submission_id, dependent: :delete_all

  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  delegate :language, :name, :navigable_parent,
           :limited?, :input_kids?, :choice?, to: :exercise

  alias_attribute :status, :submission_status
  alias_attribute :attempts_count, :attemps_count

  scope :by_exercise_ids, -> (exercise_ids) {
    where(exercise_id: exercise_ids) if exercise_ids
  }

  scope :by_usernames, -> (usernames) {
    joins(:submitter).where('users.name' => usernames) if usernames
  }

  defaults do
    self.query_results = []
    self.expectation_results = []
  end

  def evaluate_manually!(teacher_evaluation)
    update! status: teacher_evaluation[:status], manual_evaluation_comment: teacher_evaluation[:manual_evaluation]
  end

  def persist_submission!(submission)
    transaction do
      messages.destroy_all if submission_id.present?
      update! submission_id: submission.id
      update_submissions_count!
      update_last_submission!
    end
  end

  def extension
    exercise.language.extension
  end

  def notify!
    Mumukit::Nuntius.notify! 'submissions', to_resource_h unless Organization.current.silent?
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
      self.solution = exercise.single_choice? ? exercise.choice_index_for(content) : content
    end
  end

  def test
    exercise.test && language.interpolate_references_for(self, exercise.test)
  end

  def extra
    exercise.extra && language.interpolate_references_for(self, exercise.extra)
  end

  def extra_preview
    Mumukit::ContentType::Markdown.highlighted_code(language.name, extra)
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

  def to_resource_h
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

  def increment_attempts!
    self.attempts_count += 1 if should_retry?
  end

  def attempts_left
    navigable_parent.attempts_left_for(self)
  end

  # Tells wether the submitter of this
  # assignment can keep on sending submissions
  # which is true for non limited or for assignments
  # that have not reached their submissions limit
  def attempts_left?
    !limited? || attempts_left > 0
  end

  def current_content
    solution || default_content
  end

  def current_content_at(index)
    exercise.sibling_at(index).assignment_for(submitter).current_content
  end

  def default_content
    @default_content ||= language.interpolate_references_for(self, exercise.default_content)
  end

  def files
    language
      .directives_sections
      .split_sections(current_content)
      .map { |name, content| Mumuki::Domain::File.new name, content }
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
