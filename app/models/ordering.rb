module Ordering
  def self.from(order)
    order ? FixedOrdering.new(order) : NaturalOrdering
  end
end

class FixedOrdering
  def initialize(order)
    @order = order
  end

  def with_position(original_id, builder)
    builder.position = position_for(original_id)
  end

  def position_for(original_id)
    @order.index(original_id) + 1
  end
end

module NaturalOrdering
  def self.with_position(_original_id, _builder)
  end
end
