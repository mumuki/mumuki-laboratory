module WithExamsValidations
  def validate_accessible(item)
    item.access!(current_user) unless (current_user? && current_user.teacher?)
  end

end
