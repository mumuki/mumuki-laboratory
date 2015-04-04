module ExerciseSubmissionsHelper
  def repeat_submission_button(exercise)
    link_to fa_icon(:repeat, text: t(:repeat_submission)), exercise_path(exercise), class: 'btn btn-primary'
  end

  def next_exercise_button(exercise)
    next_exercise = exercise.next_for current_user
    link_to fa_icon(:forward, text: t(:next_exercise)), exercise_path(next_exercise), class: 'btn btn-primary' if next_exercise
  end

  def previous_exercise_button(exercise)
    previous_exercise = exercise.previous_for current_user
    link_to fa_icon(:backward, text: t(:previous_exercise)), exercise_path(previous_exercise), class: 'btn btn-primary' if previous_exercise
  end
end
