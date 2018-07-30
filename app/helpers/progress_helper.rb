module ProgressHelper
  def lesson_practice_key_for(stats)
    key_or_default stats, :started?, :continue_lesson, :start_lesson
  end

  def book_practice_key_for(student)
    key_or_default student, :last_exercise, :continue_practicing, :start_practicing
  end

  private

  def key_or_default(object, property, key, default_key)
    if object.try(property)
      key
    else
      default_key
    end
  end
end
