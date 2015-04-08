module WithAsyncAction
  def schedule_on_create(job)
    after_commit -> { job.run_async(id) }, on: :create
  end
end
