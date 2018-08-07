module MultipleFileEditorHelper
  def highlight_modes
    Language.all.map { |it| { extension: it.extension, highlight_mode: it.highlight_mode } }
  end

  def multifile_locales
    :insert_file_name.try { |it| { it => t(it) } }
  end
end
