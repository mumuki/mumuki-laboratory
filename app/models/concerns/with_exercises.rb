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
        joins("left join exercise_progresses
                on exercise_progresses.exercise_id = exercises.id
                and exercise_progresses.user_id = #{user.id}
               left join submissions
                on submissions.id = exercise_progresses.last_submission_id
                and submissions.status = #{Submission.passed_status}").
        where('submissions.id is null')
  end

  def next_exercise(user)
    pending_exercises(user).order('exercises.original_id asc').first
  end

  def first_exercise
    exercises.first
  end
end
