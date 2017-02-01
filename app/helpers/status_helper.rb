module StatusHelper
  def class_for_status(s)
    Status.coerce(s).iconize[:class].to_s
  end

  def icon_type_for_status(s)
    Status.coerce(s).iconize[:type].to_s
  end

  def class_for_exercise(exercise)
    class_for_status(exercise.status_for(current_user))
  end
end
