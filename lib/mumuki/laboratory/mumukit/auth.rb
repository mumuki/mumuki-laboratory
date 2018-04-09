require 'mumukit/auth'

class Mumukit::Auth::Permissions
  def protect_permissions_assignment!(other, previous)
    other ||= {}
    raise Mumukit::Auth::UnauthorizedAccessError unless assign_to?(Mumukit::Auth::Permissions.parse(other.to_h), previous)
  end
end

Mumukit::Auth.configure do |c|
  # We are not using tokens, so implementing this strategy is meaningless
  c.persistence_strategy = nil
end
