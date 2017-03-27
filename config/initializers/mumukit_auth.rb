class Mumukit::Auth::Permissions
  def accessible_organizations
    scope_for(:student)&.grants&.map { |grant| grant.to_mumukit_slug.organization }.to_set
  end
end

Mumukit::Auth.configure do |c|
  # We are not using tokens, so implementing this strategy is meaningless
  c.persistence_strategy = nil
end
