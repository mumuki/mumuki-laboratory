## Represent a local repository of exercises, at a given filesystem directory
class ExerciseRepository

  def initialize(author, dir)
    @author = author
    @dir = File.expand_path(dir)
  end

  ## Process files in the repository, logging errors
  ## to a given ImportLog, and yields each processed root
  def process_files(log)
    each_exercise_file do |root, position, original_id, title|

      description = markdown(root, 'description') || (log.no_description title; next)

      hint = markdown(root, 'hint')

      meta = meta(root) || (log.no_meta(title); next)

      test_code, test_extension = test_code(root) || (log.no_test title; next)

      extra_code, _extra_extension = extra_code(root)

      language = language(test_extension) || (log.no_lang(title); next)

      expectations = (expectations(root).try { |it| it['expectations'] } || []).map do |e|
        Expectation.new(binding: e['binding'], inspection: e['inspection'])
      end

      yield original_id,
          {title: title,
           description: description,
           hint: hint,
           tag_list: meta['tags'],
           locale: meta['locale'],
           language: language,
           expectations: expectations,
           author: @author,
           test: test_code,
           extra_code: extra_code,
           position: position}
    end
  end

  private

  def each_exercise_file
    check_exists
    Dir.glob("#{@dir}/**").sort.each_with_index do |file, index|
      basename = File.basename(file)
      match = /(\d*)_(.+)/.match basename
      next unless match
      yield file, index + 1, match[1], match[2]
    end
  end

  def check_exists
    raise "directory #{@dir} must exist" unless File.exist? @dir
  end

  def markdown(root, filename)
    path = "#{root}/#{filename}.md"
    File.read(path) if File.exist? path
  end

  def code(root,filename)
    files = Dir.glob("#{root}/#{filename}.*")
    file = files[0]
    [File.read(file), parse_extension(file)] if files.length == 1
  end

  def test_code(root)
    code(root, 'test')
  end

  def extra_code(root)
    code(root, 'extra')
  end

  def language(extension)
    Language.find_by(extension: extension)
  end

  def parse_extension(test_file)
    /.*\.(.*)/.match(File.basename(test_file))[1]
  end

  def yaml(root, filename)
    path = "#{root}/#{filename}.yml"
    YAML.load_file(path) if File.exist? path
  end

  def meta(root)
    yaml(root, 'meta')
  end

  def expectations(root)
    yaml(root, 'expectations')
  end
end
