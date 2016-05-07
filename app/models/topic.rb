class Topic < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {against: [:name, :description, :long_description]}

  include WithSearch,
          WithLocale,
          WithSlug

  validates_presence_of :name, :description

  numbered :lessons
  aggregate_of :lessons

  has_many :lessons, -> { order(number: :asc) }, dependent: :delete_all

  has_many :guides, -> { order('lessons.number') }, through: :lessons
  has_many :exercises, -> { order('exercises.number') }, through: :guides

  include WithUsages, ChildrenNavigation

  markdown_on :description, :long_description, :links

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
    self.assign_attributes json.except('lessons', 'id')
    rebuild! json['lessons'].map { |it| Guide.find_by(slug: it).as_lesson_of(self) }
    Organization.all.each { |org| org.reindex_usages! }
  end

  def index_usages!(organization)
    lessons.each do |lesson|
      organization.index_usage! lesson.guide, lesson
    end
  end

  def as_chapter_of(book)
    book.chapters.find_by(topic_id: id) || Chapter.new(topic: self, book: book)
  end
end
