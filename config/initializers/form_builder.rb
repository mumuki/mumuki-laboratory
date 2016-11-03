class ActionView::Helpers::FormBuilder
  def editor(field, language='dynamic', options={})
    text_area field, {class: 'form-control editor',
                      data: {placeholder: I18n.t(:editor_placeholder),
                             'editor-language' => language},
                      rows: 15}.deep_merge(options)
  end
end
