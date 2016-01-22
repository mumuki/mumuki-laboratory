module WithParent
  extend ActiveSupport::Concern

  included do
    validates_presence_of :number, unless: :orphan?
  end

  def orphan?
    parent.nil?
  end

  def navigable_name
    with_parent_name { super }
  end

  private

  def with_parent_name
    if orphan?
      name
    else
      yield
    end
  end
end

