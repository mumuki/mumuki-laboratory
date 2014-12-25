class ImportRepoJob < ActiveRecordJob

  def perform_with_connection(repo_id)
    ::ExerciseRepo.find(repo_id).import!
  end
end