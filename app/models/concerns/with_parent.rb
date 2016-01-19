module Navigable

  ## Plain Navigation

  def next
    siblings.select { |it| it.number == number.next }.first
  end

  def previous
    siblings.select { |it| it.number == number.pred }.first
  end

  ## Plain Navigation

  def next_for(user)
    siblings_for(user).select { |it| it.number > number }.sort_by(&:number).first
  end

  def previous_for(user)
    siblings_for(user).select { |it| it.number < number }.sort_by(&:number).last
  end

  def first_for(user)
    siblings_for(user).sort_by(&:number).first
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
    validates_presence_of :number, unless: :orphan?
  end

  def orphan?
    parent.nil?
  end

  def navigable_name
    with_parent_name { "#{number}. #{name}" }
  end

  private

  def with_parent_name
    if parent
      yield
    else
      name
    end
  end

  def qualified_number
    "#{self.class.table_name}.number"
  end
end

