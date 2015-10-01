module WithSiblings
  extend ActiveSupport::Concern

  included do
    validates_presence_of :position, unless: :orphan?
  end

  def next
    siblings.where(position: position + 1).first unless orphan?
  end

  def previous
    siblings.where(position: position - 1).first unless orphan?
  end

  def next_for(user)
    sibling_for user, "#{qualified_position} > :position", "#{qualified_position} asc"
  end

  def previous_for(user)
    sibling_for user, "#{qualified_position} < :position", "#{qualified_position} desc"
  end

  def sibling_for(user, query, order)
    siblings_for(user).where(query, position: position).order(order).first if parent
  end

  def first_for(user)
    siblings_for(user).order(position: :asc).first if parent
  end

  def orphan?
    parent.nil?
  end

  def contextualized_name
    if parent
      "#{parent.name}. #{position}. #{name}"
    else
      name
    end
  end

  private

  def qualified_position
    "#{self.class.table_name}.position"
  end
end

