module ExerciseNavigation
  extend ActiveSupport::Concern

  included do
    belongs_to :guide
  end

  def guide_done_for?(user)
    guide.done_for?(user)
  end

  def pending_siblings_for(user)
    guide.pending_exercises(user)
  end

  def parent
    guide
  end
end
