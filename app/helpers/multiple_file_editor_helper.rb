module MultipleFileEditorHelper
  def highlight_modes
    Language.all.map { |it| { extension: it.extension, highlight_mode: it.highlight_mode } }
  end

  def multifile_locales
    :insert_file_name.try { |it| { it => t(it) } }
  end

  def multifile_hidden_inputs
    hidden_field_tag('highlight-modes', highlight_modes.to_json) +
    hidden_field_tag('multifile-locales', multifile_locales.to_json) +
    hidden_field_tag('multifile-default-content', @files.to_json)
  end
end
