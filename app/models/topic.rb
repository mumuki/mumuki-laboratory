class Topic < ActiveRecord::Base
  include WithLocale

  validates_presence_of :name, :description

  numbered :lessons
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

  def rebuild!(lessons)
    transaction do
      self.lessons.delete_all
      self.lessons = lessons
      save!
    end
  end


end
