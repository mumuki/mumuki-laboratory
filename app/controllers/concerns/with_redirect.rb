module WithRedirect

  def should_choose_organization?
    current_user? && from_internet? && implicit_central?
  end

end
