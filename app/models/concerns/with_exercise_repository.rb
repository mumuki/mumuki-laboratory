module WithExerciseRepository
  def process_repository_files(dir, &block)
    log = ImportLog.new
    ExerciseRepository.new(author, dir).process_files(log, &block)
    log
  end

  def update_guide(dir)
    description = File.read File.join(dir, 'description.md')
    meta = YAML.load(File.read File.join(dir, 'meta.yml'))

    language = Language.find_by!(name: meta['language'])
    locale = meta['locale']

    guide.update!(description: description,
                  language: language,
                  locale: locale)
  end
end
