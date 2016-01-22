module WithParent
  extend ActiveSupport::Concern

  included do
    validates_presence_of :number, unless: :orphan?
  end

  def orphan?
    parent.nil?
  end

  def navigable_name
    defaulting_name { super }
  end

  private

  def defaulting_name(&block)
    parent.defaulting(name, &block)
  end
end

