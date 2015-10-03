class Playground < Exercise
  validate :ensure_playable_layout
  validate :ensure_queriable_language

  private

  def ensure_queriable_language
    errors.add(:base, :language_not_queriable) unless queriable?
  end

  def ensure_playable_layout
    errors.add(:base, :layout_not_playable) unless playable_layout?
  end

end
