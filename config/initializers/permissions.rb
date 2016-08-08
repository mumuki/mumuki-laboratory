class Mumukit::Auth::Permissions
  def organization_grants
    @grants.select {|grant| grant.is_a? Mumukit::Auth::OrgGrant}
  end
end

class Mumukit::Auth::Metadata
  def accessible_organizations
    permissions('atheneum').organization_grants.map {|grant| grant.instance_variable_get(:@org)}.to_set
  end
end
