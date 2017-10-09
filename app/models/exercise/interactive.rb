class Interactive < QueriableChallenge
  include Triable

  markdown_on :corollary
  validate :ensure_triable_language

  name_model_as Exercise

  def reset!
    super
    self.query_results = []
  end

  def queriable?
    false
  end

  def console?
    true
  end

  def hidden?
    false
  end

  def upload?
    false
  end

  private

  def ensure_triable_language
    errors.add(:base, :language_not_triable) unless triable?
  end

end
