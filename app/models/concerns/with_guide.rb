module WithGuide
  extend ActiveSupport::Concern

  included do
    belongs_to :guide
  end

  def next_for(user)
    sibling_for user, 'exercises.original_id > :id', 'exercises.original_id asc'
  end

  def previous_for(user)
    sibling_for user, 'exercises.original_id < :id', 'exercises.original_id desc'
  end

  def sibling_for(user, query, order)
    guide.pending_exercises(user).where(query, id: original_id).order(order).first  if guide
  end

  def orphan?
    guide.nil?
  end
end
