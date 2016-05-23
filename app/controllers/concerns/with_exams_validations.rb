module WithExamsValidations
  def validate_accessible(item)
    redirect_to :root unless item.accessible_by?(current_user)
  end
end
