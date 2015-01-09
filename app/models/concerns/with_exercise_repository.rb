module WithExerciseRepository
  def process_repository_files(dir, &block)
    log = ImportLog.new
    ExerciseRepository.new(author, dir).process_files(log, &block)
    log
  end
end
