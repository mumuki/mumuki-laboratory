module ProgressHelper
  def lesson_practice_key_for(stats)
    if stats.try(:started?)
      :continue_lesson
    else
      :start_lesson
    end
  end

  #FIXME refactorme: similar methods
  def book_practice_key_for(student)
    if student.try(:last_exercise)
      :continue_practicing
    else
      :start_practicing
    end
  end
end
