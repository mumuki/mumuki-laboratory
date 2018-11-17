class Topic < Content
  numbered :lessons
  aggregate_of :lessons

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
                and assignments.submission_status = #{Mumuki::Domain::Status::Submission::Passed.to_i}").
        where('assignments.id is null').
        group('public.guides.id', 'lessons.number').map(&:lesson)
  end

  def first_lesson
    lessons.first
  end

  def import_from_resource_h!(resource_h)
    self.assign_attributes resource_h.except(:lessons, :description)
    self.description = resource_h[:description].squeeze(' ')
    rebuild! resource_h[:lessons].to_a.map { |it| lesson_for(it) }
    Organization.all.each { |org| org.reindex_usages! }
  end

  def to_resource_h
    super.merge(appendix: appendix, lessons: lessons.map(&:slug)).compact
  end

  def as_chapter_of(book)
    book.chapters.find_by(topic_id: id) || Chapter.new(topic: self, book: book)
  end

  ## Forking

  def fork_to!(organization, syncer)
    rebased_dup(organization).tap do |dup|
      dup.lessons = lessons.map { |lesson| lesson.guide.fork_to!(organization, syncer).as_lesson_of(self) }
      dup.save!
      syncer.export! dup
    end
  end

  private

  def lesson_for(slug)
    Guide.find_by!(slug: slug).as_lesson_of(self)
  rescue ActiveRecord::RecordNotFound
    raise "Guide for slug #{slug} could not be found"
  end
end
