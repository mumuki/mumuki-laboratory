module StatusHelper
  def class_for_status(s)
    s.to_submission_status.iconize[:class].to_s
  end

  def icon_type_for_status(s)
    s.to_submission_status.iconize[:type].to_s
  end

  def class_for_exercise(exercise)
    class_for_status(exercise.status_for(current_user))
  end
end
