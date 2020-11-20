module Mumuki::Laboratory::Controllers::ActionRedirector
  def save_location_before!(action)
    session[redirection_variable_for(action)] = origin
  end

  def redirect_after!(action, fallback_location: root_path)
    redirection_variable = redirection_variable_for(action)
    destination = session.delete(redirection_variable).presence
    redirect_to(destination || fallback_location)
  end

  private

  def redirection_variable_for(action)
    "redirect_after_#{action}"
  end

  def origin
    Addressable::URI.heuristic_parse(request.path).to_s
  end
end
