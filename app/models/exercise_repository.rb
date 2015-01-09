## Represent a local repository of exercises, at a given filesystem directory
class ExerciseRepository

  def initialize(author, dir)
    @author = author
    @dir = File.expand_path(dir)
  end

  ## Process files in the repository, logging errors
  ## to a given ImportLog, and yields each processed file
  def process_files(log)
    each_exercise_file do |file, original_id, title|

      description_path = description_path(file) || (log.no_description title; next)

      meta = meta(file) || (log.no_meta(title); next)

      test_file = test_path(file) || (log.no_test title; next)

      language = language(test_file) || (log.no_lang(title); next)

      yield original_id,
          {title: title.titleize,
           description: File.read(description_path),
           tag_list: meta['tags'],
           locale: meta['locale'],
           language: language,
           author: @author,
           test: File.read(test_file)}
    end
  end

  private

  def each_exercise_file
    check_exists
    Dir.glob("#{@dir}/**") do |file|
      basename = File.basename(file)
      match = /(\d*)_(.+)/.match basename
      next unless match
      yield file, match[1], match[2]
    end
  end

  def check_exists
    raise "directory #{@dir} must exist" unless File.exist? @dir
  end

  def description_path(file)
    path = "#{file}/description.md"
    path if File.exist? path
  end

  def meta(file)
    path = "#{file}/meta.yml"
    YAML.load_file(path) if File.exist? path
  end

  def test_path(file)
    test_files = Dir.glob("#{file}/test.*")
    test_files[0] if test_files.length == 1
  end

  def language(test_file)
    extension = parse_extension(test_file)
    Language.find_by(extension: extension)
  end

  def parse_extension(test_file)
    /.*\.(.*)/.match(File.basename(test_file))[1]
  end
end
