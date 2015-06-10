module WithTestRunning
  def run_tests!
    run_update! do
      language.run_tests!(new_test_server_request)
    end
  end

  def new_test_server_request
    {test: exercise.test,
     extra: exercise.extra_code,
     content: content,
     locale: exercise.locale,
     expectations: exercise.expectations.as_json(only: [:binding, :inspection])}
  end
end
