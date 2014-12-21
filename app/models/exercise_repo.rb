class ExerciseRepo < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  validates_presence_of :github_url, :name, :author

  def import_from_directory!(dir)
    dir = File.expand_path(dir)
    raise "directory #{dir} must exist" unless File.exist? dir

    #TODO log importing errors
    Dir.glob("#{dir}/**") do |file|
      match = /(\d*)_(.+)/.match file
      next unless match

      original_id = match[1]
      title = match[2]

      description_path = "#{file }/description.md"
      meta = YAML.load_file "#{file }/meta.yml"

      exercise = Exercise.find_or_initialize_by(original_id: original_id, origin_id: id)
      exercise.title = title
      exercise.description = File.read description_path
      exercise.tag_list = meta['tags']
      exercise.test = "todo"
      exercise.language = "prolog"
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
