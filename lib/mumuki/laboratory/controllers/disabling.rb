module Mumuki::Laboratory::Controllers::Disabling
  def ensure_user_enabled!
    current_user.ensure_enabled! unless from_sessions?
  end
end
