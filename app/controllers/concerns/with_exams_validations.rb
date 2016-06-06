module WithExamsValidations
  def validate_accessible(item)
    raise Exceptions::ExamForbiddenException unless item_authorized?(item)
  end

  def item_authorized?(item)
    item.accessible_by?(current_user) || (current_user? && current_user.teacher?)
  end
end
