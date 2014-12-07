module Compilation
  def compile_with(plugin)
    plugin.compile(exercise.test, content)
  end

  def create_compilation_file!(compilation)
    file = Tempfile.new("mumuki.#{id}.compile")
    file.write(compilation)
    file.close
    file
  end
end