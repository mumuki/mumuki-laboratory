class Import < ActiveRecord::Base
  include WithStatus
  include WithExerciseRepository
  include WithGitGuide

  extend WithAsyncAction

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  schedule_on_create ImportGuideJob

  delegate :author, to: :guide

  def run_import_from_directory!(dir)
    update_description(dir)
    process_repository_files dir do |original_id, attributes|
      Exercise.create_or_update_for_import!(guide, original_id, attributes)
    end
  end

  def run_import!
    run_update! do
      Rails.logger.info("Importing exercises for #{guide.github_url}")
      log = nil
      with_cloned_repo 'import' do |dir|
        log = run_import_from_directory! dir
      end
      {result: log.to_s, status: :passed}
    end
  end

end
