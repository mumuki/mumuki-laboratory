module WithEditor
  extend ActiveSupport::Concern

  included do
    enum editor: [:code, :upload, :text, :single_choice, :multiple_choice, :hidden, :multiple_files, :custom, :free_form]
    validate :ensure_has_choices, if: :choice?
  end

  def choice?
    [:single_choice, :multiple_choice].include? editor.to_sym
  end

  def editor_with_defaults?
    code?
  end

  def pretty_choices
    choice_values.each_with_index.map do |choice, index|
      struct id: "content_choice_#{index}",
             index: index,
             value: choice,
             text: Mumukit::ContentType::Markdown.to_html(choice_text(choice))
    end
  end

  private

  def choice_text(choice)
    if language.name != 'text'
      Mumukit::ContentType::Markdown.inline_code choice
    else
      choice
    end
  end

  def ensure_has_choices
    errors.add(:base, :choice_problem_has_no_choices) if choices.blank?
  end
end
