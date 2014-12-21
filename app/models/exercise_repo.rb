class ExerciseRepo < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  validates_presence_of :github_url, :name, :author

  def import_from_directory!(dir)
    dir = File.expand_path(dir)
    raise "directory #{dir} must exist" unless File.exist? dir

    #TODO log importing errors
    Dir.glob("#{dir}/**") do |file|

      basename = File.basename(file)

      match = /(\d*)_(.+)/.match basename
      next unless match

      original_id = match[1]
      title = match[2]

      description_path = "#{file}/description.md"
      next unless File.exist? description_path

      meta_path = "#{file}/meta.yml"
      next unless File.exist? meta_path
      meta = YAML.load_file meta_path

      test_files = Dir.glob("#{file}/test.*")
      next if test_files.length != 1
      test_file = test_files[0]

      extension = /.*\.(.*)/.match(File.basename(test_file))[1]

      language = case extension
        when 'hs' then :haskell
        when 'pl' then :prolog
        else next
      end

      exercise = Exercise.find_or_initialize_by(original_id: original_id, origin_id: id)
      exercise.title = title.titleize
      exercise.description = File.read description_path
      exercise.tag_list = meta['tags']
      exercise.test = File.read test_file
      exercise.language = language
      exercise.author = author
      exercise.save!
    end
  end

  def import!
    #TODO handle private repositories
    Dir.mktmpdir("mumuki.#{id}.import") do |dir|
      Git.clone("https://github.com/#{github_url}", 'name', dir)
      import_from_directory! dir
    end
  end

end
