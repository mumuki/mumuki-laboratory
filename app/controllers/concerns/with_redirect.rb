module WithRedirect

  def ask_redirect?
    current_user? && from_internet? && implicit_central?
  end

end
