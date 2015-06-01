module WithFileReading
  def read_yaml_file(path)
    YAML.load_file(path) if File.exist? path
  end

  def read_file(path)
    File.read(path) if File.exist? path
  end
end
