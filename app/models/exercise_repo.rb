class ExerciseRepo < ActiveRecord::Base
  include ExerciseRepoLayout

  belongs_to :author, class_name: 'User'

  validates_presence_of :github_url, :name, :author

  def import_from_directory!(dir)
    process_files dir do |original_id, attributes|
      Exercise.create_or_update_for_import!(original_id, id, attributes)
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
