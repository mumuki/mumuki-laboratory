module EditorHelper
  def editor_defaults(language, options, styles = '')
    {class: styles,
     data: {placeholder: I18n.t(:editor_placeholder),
            'editor-language' => language},
     rows: 15}.deep_merge(options)
  end

  def read_only_editor(content, language, options = {})
    editor_options = editor_defaults(language, options, 'read-only-editor')
    text_area_tag :solution_content, content, editor_options
  end

  def spell_checked_editor(name, options = {})
    editor_options = editor_defaults('markdown', options, 'form-control mu-spell-checked-editor')
    text_area_tag name, '', editor_options
  end
end
