module WithRedirect

  def ask_redirect?
    current_user? && from_internet? && (Organization.central? || !UserMode.can_visit?(current_user))
  end

end
