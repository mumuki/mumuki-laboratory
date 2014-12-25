class Guide < ActiveRecord::Base
  include ExerciseRepositoryLayout

  belongs_to :author, class_name: 'User'

  has_many :exercises

  validates_presence_of :github_url, :name, :author

  after_commit :schedule_import!

  def import_from_directory!(dir)
    process_files dir do |original_id, attributes|
      Exercise.create_or_update_for_import!(self, original_id, attributes)
    end
  end

  def import!
    Rails.logger.info("Importing exercises for #{git_url}")
    #TODO handle private repositories
    Dir.mktmpdir("mumuki.#{id}.import") do |dir|
      Git.clone(git_url, name, path: dir)
      import_from_directory! dir
    end
  end

  def schedule_import!
    ImportGuideJob.run_async(id)
  end

  def git_url
    "https://github.com/#{github_url}"
  end

end
