module WithExamsValidations
  def validate_accessible(item)
    redirect_to :root, alert: t(:item_not_accessible) unless item_authorized?(item)
  end

  def item_authorized?(item)
    item.accessible_by?(current_user) || (current_user? && current_user.teacher?)
  end
end
