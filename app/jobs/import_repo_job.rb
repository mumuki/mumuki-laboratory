class ImportRepoJob
  include SuckerPunch::Job

  def perform(repo_id)
    ActiveRecord::Base.connection_pool.with_connection do
      ::ExerciseRepo.find(repo_id).import!
    end
  end
end