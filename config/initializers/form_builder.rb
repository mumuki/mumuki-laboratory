include EditorHelper

class ActionView::Helpers::FormBuilder
  def editor(field, language = 'dynamic', options = {})
    text_area field, editor_defaults(language, options, 'form-control editor')
  end
end
