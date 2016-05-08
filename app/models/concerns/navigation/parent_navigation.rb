module ParentNavigation
  extend ActiveSupport::Concern

  def leave(user)
    navigable_parent.next(user)
  end

  def orphan?
    navigable_parent.nil?
  end

  def navigable_name
    defaulting_name { super }
  end

  def navigable_parent
    structural_parent.usage_in_organization
  end

  #required :structural_parent

  private

  def defaulting_name(&block)
    navigable_parent.defaulting(name, &block)
  end
end

