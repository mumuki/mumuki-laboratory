module WithLanguage
  extend ActiveSupport::Concern

  included do
    belongs_to :language
    validate :language_consistent_with_guide, if: :guide
    delegate :visible_success_output?, :highlight_mode, :queriable?, to: :language
  end

  private

  def language_consistent_with_guide
    errors.add(:base, :same_language_of_guide) if language != guide.language
  end

end