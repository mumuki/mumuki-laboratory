module WithTestRunning
  def run_tests!
    run_update! do
      language.run_tests!(new_test_server_request).except(:response_type)
    end
  end

  def new_test_server_request
    {test: exercise.test,
     extra: exercise.extra_code,
     content: content,
     locale: exercise.locale,
     expectations: exercise.expectations.as_json(only: [:binding, :inspection])} #FIXME persist expectations as JSON, not records
  end
end
