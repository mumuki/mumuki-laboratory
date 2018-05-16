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
        exercise.assignment_for(user)&.destroy!
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
                and assignments.status = #{Mumuki::Laboratory::Status::Assignment::Passed.to_i}").
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

  def import_from_json!(json)
    self.assign_attributes json.except('exercises', 'language', 'id_format', 'id', 'teacher_info', 'collaborators')
    self.language = Language.for_name(json['language'])
    self.save!

    json['exercises'].each_with_index do |e, i|
      exercise = Exercise.find_by(guide_id: self.id, bibliotheca_id: e['id'])

      exercise = exercise ?
          exercise.ensure_type!(e['type']) :
          Exercise.class_for(e['type']).new(guide_id: self.id, bibliotheca_id: e['id'])

      exercise.import_from_json! (i+1), e
    end

    self.exercises.where('number > ?', json['exercises'].size).destroy_all
    reload
  end

  def as_lesson_of(topic)
    topic.lessons.find_by(guide_id: id) || Lesson.new(guide: self, topic: topic)
  end

  def as_complement_of(book) #FIXME duplication
    book.complements.find_by(guide_id: id) || Complement.new(guide: self, book: book)
  end

end
