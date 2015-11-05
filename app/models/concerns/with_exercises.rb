module WithExercises
  extend ActiveSupport::Concern

  included do
    has_many :exercises, -> { order(position: :asc) }
  end

  def exercises_count
    exercises.count
  end

  def pending_exercises(user)
    exercises.
        joins("left join public.assignments assignments
                on assignments.exercise_id = exercises.id
                and assignments.submitter_id = #{user.id}
                and assignments.status = #{Status::Passed.to_i}").
        where('assignments.id is null')
  end

  def next_exercise(user)
    pending_exercises(user).order('public.exercises.position asc').first
  end

  def first_exercise
    exercises.first
  end
end
