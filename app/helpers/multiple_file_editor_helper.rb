module MultipleFileEditorHelper
  def highlight_modes
    Language.all.map { |it| { extension: it.extension, highlight_mode: it.highlight_mode } }
  end
end
