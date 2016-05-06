class Topic < ActiveRecord::Base
  INDEXED_ATTRIBUTES = { against: [:name, :description, :long_description] }

  include WithSearch,
          WithLocale,
          WithSlug

  validates_presence_of :name, :description

  numbered :lessons
  aggregate_of :lessons

  has_many :lessons, -> { order(number: :asc) }, dependent:  :delete_all
  has_many :usages, as: :item

  has_many :guides, -> { order('lessons.number') }, through: :lessons
  has_many :exercises, -> { order('exercises.number') }, through: :guides

  include ChildrenNavigation

  markdown_on :description, :long_description, :links

  def usage_in_organization
    Chapter.where(topic_id: id).first #FIXME
  end

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
    rebuild! json['lessons'].map { |it| Guide.find_by_slug(slug: it['slug']).to_lesson }
  end

  def to_chapter
    usage_in_organization || Chapter.new(topic: self)
  end
end
