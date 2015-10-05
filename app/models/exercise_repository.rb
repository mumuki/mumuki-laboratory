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

class ExerciseRepository

  attr_reader :reader

  def initialize(author, language, dir)
    @author = author
    @language = language
    @dir = File.expand_path(dir)
    @reader = ExerciseReader.new(@dir)
  end

  ## Process files in the repository, logging errors
  ## to a given ImportLog, and yields each processed root
  def process_files(log)
    each_exercise_file do |root, position, original_id, name|
      description = reader.markdown(root, 'description') || (log.no_description name; next)
      meta = reader.meta(root) || (log.no_meta(name); next)

      hint = reader.markdown(root, 'hint')
      corollary = reader.markdown(root, 'corollary')

      test_code = reader.test_code(root)
      extra_code = reader.extra_code(root)

      expectations = (reader.expectations(root).try { |it| it['expectations'] } || []).map do |e|
        {binding: e['binding'], inspection: e['inspection']}
      end

      yield original_id,
          {name: name,
           description: description,
           hint: hint,
           corollary: corollary,
           tag_list: meta['tags'],
           locale: meta['locale'],
           layout: meta['layout'] || Exercise.default_layout,
           language: @language,
           expectations: expectations,
           author: @author,
           test: test_code,
           extra_code: extra_code,
           type: (meta['type'] || 'problem').camelize,
           position: position}
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
