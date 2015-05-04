class Import < ActiveRecord::Base
  extend WithAsyncAction

  include WithStatus

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  schedule_on_create ImportGuideJob

  delegate :author, to: :guide

  def run_import!
    run_update! do
      Rails.logger.info("Importing exercises for #{guide.github_url}")
      log = nil
      committer.with_cloned_repo guide, 'import' do |dir|
        log = read_guide! dir
      end
      guide.update_contributors!
      {result: log.to_s, status: :passed}
    end
  end

  def read_guide!(dir)
    order = read_meta! dir
    read_description! dir
    read_exercises! dir, order
  end

  def read_description!(dir)
    guide.update!(description: File.read(File.join(dir, 'description.md')))
  end

  def read_meta!(dir)
    meta = YAML.load_file(File.join(dir, 'meta.yml'))

    guide.language = Language.find_by!(name: meta['language'].downcase)
    guide.locale = meta['locale']
    meta['original_id_format'].try { |format| guide.original_id_format = format }

    guide.save!

    meta['order']
  end

  def read_exercises!(dir, order = nil)
    ordering = Ordering.from order
    log = ImportLog.new
    ExerciseRepository.new(author, dir).process_files(log) do |original_id, attributes|
      Exercise.create_or_update_for_import!(guide, original_id, ordering.with_position(original_id, attributes))
    end
    log
  end
end
