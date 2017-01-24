module WithReferer
  def from_sessions?
    params['controller'] == 'sessions'
  end

  def from_logout?
    from_sessions? && params['action'] == 'destroy'
  end

  def from_login_callback?
    from_sessions? && params['action'] == 'callback'
  end
end
