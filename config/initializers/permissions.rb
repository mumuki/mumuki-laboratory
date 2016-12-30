class Mumukit::Auth::Permissions
  def accessible_organizations
    scope_for(:student)&.grants&.map {|grant| grant.instance_variable_get(:@first)}.to_set
  end
end
