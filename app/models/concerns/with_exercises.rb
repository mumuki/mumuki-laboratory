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
        at_locale.
        joins("left join solutions
                on solutions.exercise_id = exercises.id
                and solutions.submitter_id = #{user.id}
                and solutions.status = #{Status::Passed.to_i}").
        where('solutions.id is null')
  end

  def next_exercise(user)
    pending_exercises(user).order('exercises.position asc').first
  end

  def first_exercise
    exercises.first
  end
end
