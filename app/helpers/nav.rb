module Nav
  def next_exercise_button(exercise)
    sibling_exercise_button(exercise.next_for(current_user), :next_exercise, 'chevron-right', 'btn btn-success', true)
  end

  def next_exercise_nav_button(exercise)
    sibling_exercise_button(exercise.next, :next_exercise, 'chevron-circle-right', 'text-info', true)
  end

  def previous_exercise_nav_button(exercise)
    sibling_exercise_button(exercise.previous, :previous_exercise, 'chevron-circle-left', 'text-info')
  end

  def sibling_exercise_button(sibling, key, icon, clazz, right=false)
    link_to fa_icon(icon, text: t(key), right: right), exercise_path(sibling), class: clazz if sibling
  end
end
