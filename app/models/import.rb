class Import < RepositoryOperation
  include WithFileReading

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      Rails.logger.info("Importing exercises for #{guide.github_url}")
      log = nil
      with_cloned_repo do |dir|
        log = read_guide! dir
      end
      guide.update_contributors!
      {result: log.to_s, status: :passed}
    end
  end

  def read_guide!(dir)
    order = read_meta! dir
    read_description! dir
    read_corollary! dir
    read_extra! dir
    read_exercises! dir, order
  end

  def read_description!(dir)
    description = read_file(File.join(dir, 'description.md'))
    raise 'Missing description file' unless description
    guide.update!(description: description)
  end

  def read_corollary!(dir)
    guide.update!(corollary: read_file(File.join(dir, 'corollary.md')))
  end

  def read_extra!(dir)
    guide.update!(extra_code: read_code_file(dir, 'extra'))
  end

  def read_meta!(dir)
    meta = read_yaml_file(File.join(dir, 'meta.yml'))

    guide.language = Language.find_by!(name: meta['language'].downcase)
    guide.locale = meta['locale']
    meta['original_id_format'].try { |format| guide.original_id_format = format }
    meta['learning'].try { |learning| guide.learning = learning }
    guide.save!

    meta['order']
  end

  def read_exercises!(dir, order = nil)
    ordering = Ordering.from order
    log = ImportLog.new
    ExerciseRepository.new(author, language, dir).process_files(log) do |original_id, attributes|
      Exercise.create_or_update_for_import!(guide, original_id, ordering.with_position(original_id, attributes))
    end
    log
  end
end
