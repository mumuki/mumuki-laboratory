module ExerciseRepositoryLayout

  def process_files(dir)
    #TODO log importing errors
    each_exercise_file(dir) do |file, original_id, title|
      description_path = "#{file}/description.md"
      next unless File.exist? description_path

      meta_path = "#{file}/meta.yml"
      next unless File.exist? meta_path
      meta = YAML.load_file meta_path

      test_files = Dir.glob("#{file}/test.*")
      next if test_files.length != 1
      test_file = test_files[0]

      extension = /.*\.(.*)/.match(File.basename(test_file))[1]

      language = Language.find_by!(extension: extension) rescue next

      yield original_id,
          {title: title.titleize,
           description: File.read(description_path),
           tag_list: meta['tags'],
           language: language,
           author: author,
           test: File.read(test_file)}
    end
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
