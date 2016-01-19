module Navigable

  ## Plain Navigation

  def next
    siblings.select { |it| it.position == position.next }.first
  end

  def previous
    siblings.select { |it| it.position == position.pred }.first
  end

  ## Plain Navigation

  def next_for(user)
    siblings_for(user).select { |it| it.position > position }.sort_by(&:position).first
  end

  def previous_for(user)
    siblings_for(user).select { |it| it.position < position }.sort_by(&:position).last
  end

  def first_for(user)
    siblings_for(user).sort_by(&:position).first
  end

  ##
  # Answers a - maybe empty - list of siblings
  #required :siblings

  ##
  # Answers a - maybe empty - list of pending siblings for the given user
  #required :siblings_for
end

module WithParent
  extend ActiveSupport::Concern

  included do
    include Navigable
    validates_presence_of :position, unless: :orphan?
  end

  def orphan?
    parent.nil?
  end

  def contextualized_name
    with_parent_name { "#{position}. #{name}" }
  end

  private

  def with_parent_name
    if parent
      yield
    else
      name
    end
  end

  def qualified_position
    "#{self.class.table_name}.position"
  end
end

