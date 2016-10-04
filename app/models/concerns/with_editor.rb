module WithEditor
  extend ActiveSupport::Concern

  included do
    enum editor: [:code, :upload, :text, :single_choice, :multiple_choice, :hidden]
    validate :ensure_choice_has_options, if: :choice_editor?
  end

  def choice_editor?
    [:single_choice, :multiple_choice].include? editor.to_sym
  end

  def editor_with_defaults?
    code?
  end

  private

  def ensure_choice_has_options
    errors.add(:base, :choice_has_no_options) if options.blank?
  end
end
