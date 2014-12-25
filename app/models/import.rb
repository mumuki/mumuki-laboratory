class Import < ActiveRecord::Base
  include WithStatus
  include ExerciseRepositoryLayout

  belongs_to :guide

  after_commit :schedule_run_import!, on: :create

  delegate :author, to: :guide

  def run_import_from_directory!(dir)
    process_files dir do |original_id, attributes|
      Exercise.create_or_update_for_import!(guide, original_id, attributes)
    end
  end

  def run_import!
    run_update! do
      Rails.logger.info("Importing exercises for #{guide.github_url}")
      #TODO handle private repositories
      Dir.mktmpdir("mumuki.#{id}.import") do |dir|
        Git.clone(guide.github_url, guide.name, path: dir)
        run_import_from_directory! dir
      end
      [:passed, '']
    end
  end

  def schedule_run_import!
    ImportGuideJob.run_async(id)
  end
end
