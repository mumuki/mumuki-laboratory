module ExerciseSubmissionsHelper
  include ExpectationsTranslate

  def repeat_submission_button(exercise)
    link_to fa_icon(:repeat, text: t(:repeat_submission)), exercise_path(exercise), class: 'btn btn-primary'
  end

  def next_exercise_button(exercise)
    sibling_exercise_button(exercise.next_for(current_user), :next_exercise, :forward)
  end

  def previous_exercise_button(exercise)
    sibling_exercise_button(exercise.previous_for(current_user), :previous_exercise, :backward)
  end

  def sibling_exercise_button(sibling, key, icon)
    link_to fa_icon(icon, text: t(key)), exercise_path(sibling), class: 'btn btn-primary' if sibling
  end
end
