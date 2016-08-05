module Referer
  def from_sessions?
    params['controller'] == 'sessions'
  end

  def from_logout?
    from_sessions? && params['action'] == 'destroy'
  end

  def from_login_callback?
    from_sessions? && params['action'] == 'callback'
  end

  def from_internet?
    !request_host_include? %w(mumuki localmumuki)
  end

  def request_host_include?(hosts)
    hosts.any? { |host| URI.parse(request.referer).host.include? host } rescue false
  end

end
