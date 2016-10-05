module WithEditor
  extend ActiveSupport::Concern

  included do
    enum editor: [:code, :upload, :text, :single_choice, :multiple_choice, :hidden]
    validate :ensure_has_choices, if: :choice?
  end

  def choice?
    [:single_choice, :multiple_choice].include? editor.to_sym
  end

  def editor_with_defaults?
    code?
  end

  private

  def ensure_has_choices
    errors.add(:base, :choice_problem_has_no_choices) if choices.blank?
  end
end
