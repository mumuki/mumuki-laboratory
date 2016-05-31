module Recurrence
  def visitor_recurrent?
    current_user? && current_user.last_guide.present?
  end

  def visitor_comes_from_internet?
    !request_host_include? %w(mumuki localmumuki)
  end

  def request_host_include?(hosts)
    hosts.any? { |host| Addressable::URI.parse(request.referer).host.include? host } rescue false
  end
end