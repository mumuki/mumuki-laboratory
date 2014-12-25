module TestRunning
  def schedule_test_run!
    TestRunnerJob.run_async(id)
  end

  def run_tests!
    run_update! do
      plugin = self.plugin
      compilation = compile_with(plugin)
      file = create_compilation_file!(compilation)
      results = plugin.run_test_file!(file)
      file.unlink
      results
    end
  end
end