class LogicFile
  attr_reader :name, :content

  def initialize(name, content)
    @name = name
    @content = content
  end

  def highlight_mode
    Language.find_by(extension: extension)&.highlight_mode || extension
  end

  def extension
    File.extname(name).delete '.'
  end
end
