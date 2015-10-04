class Playground < Exercise
  validate :ensure_playable_layout
  validate :ensure_queriable_language

  extend FriendlyId
  friendly_id :generate_custom_slug, use: [:slugged, :finders]

  def self.model_name
    Exercise.model_name
  end

  private

  def ensure_queriable_language
    errors.add(:base, :language_not_queriable) unless queriable?
  end

  def ensure_playable_layout
    errors.add(:base, :layout_not_playable) unless playable_layout?
  end

end
