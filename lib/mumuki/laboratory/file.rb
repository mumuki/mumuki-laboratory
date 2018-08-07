module Mumuki::Laboratory
  class File
    attr_reader :name, :content

    def self.valid_filename?(name)
      name.include? '.'
    end

    def initialize(name, content)
      @name = name
      @content = content
    end

    def highlight_mode
      Language.find_by(extension: extension)&.highlight_mode || extension
    end

    def extension
      name.get_file_extension
    end
  end
end
