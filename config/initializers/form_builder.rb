class ActionView::Helpers::FormBuilder
  def editor(field, language='dynamic', options={})
    text_area field, {class: 'form-control editor', 'data-editor-language' => language, rows: 15}.merge(options)
  end
end
