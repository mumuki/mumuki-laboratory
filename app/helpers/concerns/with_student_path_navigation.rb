module WithStudentPathNavigation
  def next_button(navigable)
    return unless navigable
    ContinueNavigation.new(self).button(navigable) || RevisitNavigation.new(self).button(navigable)
  end

  def next_lesson_button(guide)
    next_button(guide.lesson) || chapter_finished(guide.chapter)
  end

  def next_exercise_button(exercise)
    next_button(exercise) || next_button(exercise.guide.lesson)
  end
end
