module ParentNavigation
  extend ActiveSupport::Concern

  included do
    validates_presence_of :number, unless: :orphan?
  end

  def leave(user)
    parent.next(user) 
  end

  def orphan?
    parent.nil?
  end

  def navigable_name
    defaulting_name { super }
  end

  #required :parent

  private

  def defaulting_name(&block)
    parent.defaulting(name, &block)
  end
end

