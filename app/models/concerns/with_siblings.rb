module WithSiblings
  extend ActiveSupport::Concern

  included do
    validates_presence_of :position, unless: :orphan?
  end

  def next
    siblings.select { |it| it.position == position + 1 }.first unless orphan?
  end

  def previous
    siblings.select { |it| it.position == position - 1 }.first unless orphan?
  end

  def next_for(user)
    siblings_for(user).select { |it| it.position > position }.sort_by(&:position).first unless orphan?
  end

  def previous_for(user)
    siblings_for(user).select { |it| it.position < position }.sort_by(&:position).last unless orphan?
  end

  def first_for(user)
    siblings_for(user).sort_by(&:position).first unless orphan?
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

