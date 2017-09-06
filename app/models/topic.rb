class Topic < Content
  numbered :lessons
  has_many :lessons, -> { order(number: :asc) }, dependent: :delete_all

  has_many :guides, -> { order('lessons.number') }, through: :lessons
  has_many :exercises, -> { order('exercises.number') }, through: :guides

  markdown_on :appendix

  def pending_lessons(user)
    guides.
        joins('left join public.exercises exercises
                on exercises.guide_id = guides.id').
        joins("left join public.assignments assignments
                on assignments.exercise_id = exercises.id
                and assignments.submitter_id = #{user.id}
                and assignments.status = #{Status::Passed.to_i}").
        where('assignments.id is null').
        group('public.guides.id', 'lessons.number').map(&:lesson)
  end

  def first_lesson
    lessons.first
  end

  def import_from_json!(json)
    self.assign_attributes json.except('lessons', 'id', 'description', 'teacher_info')
    self.description = json['description'].squeeze(' ')
    rebuild! lessons: json['lessons'].map { |it| lesson_for(it) }
    Organization.reindex_all!
  end

  def as_chapter_of(book)
    book.chapters.find_by(topic_id: id) || Chapter.new(topic: self, book: book)
  end

  private

  def lesson_for(slug)
    Guide.find_by!(slug: slug).as_lesson_of(self)
  rescue ActiveRecord::RecordNotFound
    raise "Guide for slug #{slug} could not be found"
  end
end
