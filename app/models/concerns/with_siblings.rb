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

  def orphan?
    parent.nil?
  end
end

