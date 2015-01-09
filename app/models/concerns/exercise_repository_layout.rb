module ExerciseRepositoryLayout

  def process_files(dir)
    out = []
    each_exercise_file(dir) do |file, original_id, title|
      description_path = "#{file}/description.md"

      unless File.exist? description_path
        out << "Description does not exist for #{title}"
        next
      end

      meta_path = "#{file}/meta.yml"
      unless File.exist? meta_path
        out << "Meta does not exist for #{title}"
        next
      end
      meta = YAML.load_file meta_path

      test_files = Dir.glob("#{file}/test.*")
      if test_files.length != 1
        out << "There must be exactly 1 test file for #{title}"
        next
      end
      test_file = test_files[0]

      extension = /.*\.(.*)/.match(File.basename(test_file))[1]

      language = Language.find_by(extension: extension)
      unless language
        out << "Language not found for extension #{extension}, for #{title}"
        next
      end

      yield original_id,
          {title: title.titleize,
           description: File.read(description_path),
           tag_list: meta['tags'],
           locale: meta['locale'],
           language: language,
           author: author,
           test: File.read(test_file)}
    end
    out.join(', ')
  end

  private

  def each_exercise_file(dir)
    dir = File.expand_path(dir)
    raise "directory #{dir} must exist" unless File.exist? dir
    Dir.glob("#{dir}/**") do |file|
      basename = File.basename(file)
      match = /(\d*)_(.+)/.match basename
      next unless match
      yield file, match[1], match[2]
    end
  end
end
