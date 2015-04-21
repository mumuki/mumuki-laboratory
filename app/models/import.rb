class Import < ActiveRecord::Base
  extend WithAsyncAction

  include WithStatus
  include WithGitGuide

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  schedule_on_create ImportGuideJob

  delegate :author, to: :guide

  def run_import!
    run_update! do
      Rails.logger.info("Importing exercises for #{guide.github_url}")
      log = nil
      with_cloned_repo 'import' do |dir|
        log = read_guide! dir
      end
      {result: log.to_s, status: :passed}
    end
  end

  def read_guide!(dir)
    read_meta! dir
    read_description! dir
    read_exercises! dir
  end

  def read_description!(dir)
    guide.update!(description: File.read(File.join(dir, 'description.md')))
  end

  def read_meta!(dir)
    meta = YAML.load_file(File.join(dir, 'meta.yml'))

    language = Language.find_by!(name: meta['language'])
    locale = meta['locale']

    guide.update!(language: language, locale: locale)
  end

  def read_exercises!(dir)
    log = ImportLog.new
    ExerciseRepository.new(author, dir).process_files(log) do |original_id, attributes|
      Exercise.create_or_update_for_import!(guide, original_id, attributes)
    end
    log
  end

end
