class BasePlugin
  def run_test_file!(file)
    [%x{#{run_test_command(file)}}, $?.success? ? :passed : :failed]
  end
end