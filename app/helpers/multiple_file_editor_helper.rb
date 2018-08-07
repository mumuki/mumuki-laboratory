module MultipleFileEditorHelper
  def highlight_modes
    Language.all.map { |it| { extension: it.extension, highlight_mode: it.highlight_mode } }
  end

  def multifile_locales
    [
      :insert_file_name
    ].map { |it| [it, t(it)] }.to_h
  end
end
