class Mumukit::Auth::Permissions
  def accessible_organizations
    orgs = scope_for(:student)&.grants&.map {|grant| grant.instance_variable_get(:@slug)}.compact.map(&:first).to_set
  end
end
