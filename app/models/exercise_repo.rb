class ExerciseRepo < ActiveRecord::Base
  include ExerciseRepoLayout

  belongs_to :author, class_name: 'User'

  has_many :exercises, foreign_key: :origin_id

  validates_presence_of :github_url, :name, :author

  after_commit :schedule_import!

  def import_from_directory!(dir)
    process_files dir do |original_id, attributes|
      Exercise.create_or_update_for_import!(self, original_id, attributes)
    end
  end

  def import!
    #TODO handle private repositories
    Dir.mktmpdir("mumuki.#{id}.import") do |dir|
      Git.clone("https://github.com/#{github_url}", name, path: dir)
      import_from_directory! dir
    end
  end

  def schedule_import!
    ImportRepoJob.new.async.perform(id)
  end

end
