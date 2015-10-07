## Represent a local repository of exercises, at a given filesystem directory

class ExerciseReader
  include WithFileReading

  def initialize(dir)
    raise "directory #{dir} must exist" unless File.exist? dir
    @dir = dir
  end

  def markdown(root, filename)
    read_file "#{root}/#{filename}.md"
  end

  def test_code(root)
    read_code_file(root, 'test')
  end

  def extra_code(root)
    read_code_file(root, 'extra')
  end

  def yaml(root, filename)
    read_yaml_file "#{root}/#{filename}.yml"
  end

  def meta(root)
    yaml(root, 'meta')
  end

  def expectations(root)
    yaml(root, 'expectations')
  end
end


class GuideReader

  attr_reader :reader

  def initialize(author, language, dir)
    @author = author
    @language = language
    @dir = File.expand_path(dir)
    @reader = ExerciseReader.new(@dir)
  end

  ## Process files in the repository, logging errors
  ## to a given ImportLog, and yields each processed root
  def read_exercises(log)
    each_exercise_file do |root, position, original_id, name|
      builder = ExerciseBuilder.new
      builder.meta = reader.meta(root) || (log.no_meta(name); next)
      builder.original_id = original_id
      builder.name = name
      builder.description = reader.markdown(root, 'description') || (log.no_description name; next)
      builder.position = position
      builder.hint = reader.markdown(root, 'hint')
      builder.corollary = reader.markdown(root, 'corollary')
      builder.test = reader.test_code(root)
      builder.extra_code = reader.extra_code(root)
      builder.language = @language
      builder.author = @author
      builder.expectations = reader.expectations(root).try { |it| it['expectations'] }
      yield builder
    end
  end

  private

  def each_exercise_file
    Dir.glob("#{@dir}/**").sort.each_with_index do |file, index|
      basename = File.basename(file)
      match = /(\d*)_(.+)/.match basename
      next unless match
      yield file, index + 1, match[1].to_i, match[2]
    end
  end
end
