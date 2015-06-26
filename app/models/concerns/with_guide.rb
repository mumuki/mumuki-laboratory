module WithGuide
  extend ActiveSupport::Concern

  included do
    include WithSiblings

    belongs_to :guide
  end

  def next_for(user)
    sibling_for user, 'exercises.position > :position', 'exercises.position asc'
  end

  def previous_for(user)
    sibling_for user, 'exercises.position < :position', 'exercises.position desc'
  end

  def sibling_for(user, query, order)
    guide.pending_exercises(user).where(query, position: position).order(order).first  if guide
  end

  def siblings
    guide.exercises
  end

  def orphan?
    guide.nil?
  end
end
