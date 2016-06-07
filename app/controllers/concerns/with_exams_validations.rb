module WithExamsValidations
  def validate_accessible(item)
    raise Exceptions::ExamForbiddenException unless item_authorized?(item)
  end

  def item_authorized?(item)
    item.access!(current_user) unless should_validate?
  end

  def should_validate?
    raise Exceptions::ExamForbiddenException unless (current_user? && current_user.teacher?)
  end
end
