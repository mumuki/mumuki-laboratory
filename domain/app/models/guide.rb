class Guide < Content
  include WithStats,
          WithExpectations,
          WithLanguage

  markdown_on :corollary

  numbered :exercises
  has_many :exercises, -> { order(number: :asc) }, dependent:  :delete_all

  self.inheritance_column = nil

  enum type: [:learning, :practice]

  def clear_progress!(user)
    transaction do
      exercises.each do |exercise|
        exercise.find_assignment_for(user)&.destroy!
      end
    end
  end

  def lesson
    usage_in_organization_of_type Lesson
  end

  def chapter
    lesson.try(:chapter) #FIXME temporary
  end

  def exercises_count
    exercises.count
  end

  def pending_exercises(user)
    exercises.
        joins("left join public.assignments assignments
                on assignments.exercise_id = exercises.id
                and assignments.submitter_id = #{user.id}
                and assignments.submission_status = #{Mumuki::Domain::Status::Submission::Passed.to_i}").
        where('assignments.id is null')
  end

  def next_exercise(user)
    pending_exercises(user).order('public.exercises.number asc').first
  end

  def first_exercise
    exercises.first
  end

  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  def done_for?(user)
    stats_for(user).done?
  end

  def import_from_resource_h!(resource_h)
    self.assign_attributes whitelist_attributes(resource_h)
    self.language = Language.for_name(resource_h.dig(:language, :name))
    self.save!

    resource_h[:exercises]&.each_with_index do |e, i|
      exercise = Exercise.find_by(guide_id: self.id, bibliotheca_id: e[:id])
      exercise_type = e[:type] || 'problem'

      exercise = exercise ?
          exercise.ensure_type!(exercise_type.as_module_name) :
          exercise_type.as_module.new(guide_id: self.id, bibliotheca_id: e[:id])

      exercise.import_from_resource_h! (i+1), e
    end

    new_ids = resource_h[:exercises].map { |it| it[:id] }
    self.exercises.where.not(bibliotheca_id: new_ids).destroy_all

    reload
  end

  def to_resource_h
    as_json(only: %i(beta type id_format private expectations corollary teacher_info authors collaborators extra))
      .symbolize_keys
      .merge(super)
      .merge(exercises: exercises.map(&:to_resource_h))
      .merge(language: language.to_embedded_resource_h)
      .compact
  end

  def to_markdownified_resource_h
    to_resource_h.tap do |guide|
      %i(corollary description teacher_info).each do |it|
        guide[it] = Mumukit::ContentType::Markdown.to_html(guide[it])
      end
      %i(hint corollary description teacher_info).each do |it|
        guide[:exercises].each { |exercise| exercise[it] = Mumukit::ContentType::Markdown.to_html(exercise[it]) }
      end
    end
  end

  def as_lesson_of(topic)
    topic.lessons.find_by(guide_id: id) || Lesson.new(guide: self, topic: topic)
  end

  def as_complement_of(book) #FIXME duplication
    book.complements.find_by(guide_id: id) || Complement.new(guide: self, book: book)
  end

  def resettable?
    usage_in_organization.resettable?
  end

  def fork_to!(organization, syncer)
    rebased_dup(organization).tap do |dup|
      dup.exercises = exercises.map(&:dup)
      dup.save!
      syncer.export! dup
    end
  end
end
