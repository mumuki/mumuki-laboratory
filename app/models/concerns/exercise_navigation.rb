module ExerciseNavigation
  extend ActiveSupport::Concern

  included do
    include Navigable
    include WithParent

    belongs_to :guide
  end

  def guide_done_for?(user)
    guide.done_for?(user)
  end

  def siblings_for(user)
    guide.pending_exercises(user)
  end

  def siblings
    guide.exercises
  end

  def parent
    guide
  end
end
