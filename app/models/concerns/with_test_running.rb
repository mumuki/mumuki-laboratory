module WithTestRunning
  def run_tests!
    run_update! do
      language.run_tests!(new_test_server_request).except(:response_type)
    end
    EventNotificationJob.run_async(
        self.as_json(except: :exercise_id,
                     include: {
                         exercise: {only: [:id, :guide_id]},
                         submitter: {only: [:id, :name]}}))
  end

  def new_test_server_request
    {test: exercise.test,
     extra: exercise.extra_code,
     content: content,
     locale: exercise.locale,
     expectations: exercise.expectations}
  end
end
