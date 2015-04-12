module WithExerciseRepository
  def process_repository_files(dir, &block)
    log = ImportLog.new
    ExerciseRepository.new(author, dir).process_files(log, &block)
    log
  end

  def update_description(dir)
    path = File.join dir, 'description.md'
    guide.update!(description: File.read(path)) if File.exist? path
  end
end
