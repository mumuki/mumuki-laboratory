module WithGuide
  extend ActiveSupport::Concern

  included do
    include WithSiblings

    belongs_to :guide
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
