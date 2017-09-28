class Interactive < QueriableChallenge
  include Seekable

  markdown_on :corollary
  validate :ensure_seekable_language

  name_model_as Exercise

  def reset!
    super
    self.step_results = []
  end

  def queriable?
    false
  end

  private

  def ensure_seekable_language
    errors.add(:base, :language_not_seekable) unless seekable?
  end

end
