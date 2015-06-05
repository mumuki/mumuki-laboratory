module WithFileReading

  def read_code_file(root,filename)
    files = Dir.glob("#{root}/#{filename}.*")
    file = files[0]
    read_file(file) if files.length == 1
  end

  def read_yaml_file(path)
    YAML.load_file(path) if File.exist? path
  end

  def read_file(path)
    File.read(path) if File.exist? path
  end
end
