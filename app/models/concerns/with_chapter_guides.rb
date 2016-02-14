module WithChapterGuides
  extend ActiveSupport::Concern

  included do
    has_many :chapter_guides, -> { order(number: :asc) }
    has_many :guides, -> { order('chapter_guides.number') }, through: :chapter_guides
  end

  def pending_guides(user)
    guides.
        joins('left join public.exercises exercises
                on exercises.guide_id = guides.id').
        joins("left join public.assignments assignments
                on assignments.exercise_id = exercises.id
                and assignments.submitter_id = #{user.id}
                and assignments.status = #{Status::Passed.to_i}").
        where('assignments.id is null').
        group('public.guides.id', 'chapter_guides.number')
  end

  def first_guide
    guides.first
  end
end

