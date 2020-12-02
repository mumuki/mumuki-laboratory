module GamificationHelper
  def in_gamified_context?
    Organization.current.gamification_enabled?
  end
end
