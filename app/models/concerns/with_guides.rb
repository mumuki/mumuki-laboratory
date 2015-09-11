module WithGuides
  extend ActiveSupport::Concern

  included do
    has_many :guides, -> { order(:position) }
  end

  def pending_guides(user)
    guides.
        joins('left join exercises
                on exercises.guide_id = guides.id').
        joins("left join solutions
                on solutions.exercise_id = exercises.id
                and solutions.submitter_id = #{user.id}
                and solutions.status = #{Status::Passed.to_i}").
        where('solutions.id is null').
        uniq
  end

  def first_guide
    guides.first
  end
end

