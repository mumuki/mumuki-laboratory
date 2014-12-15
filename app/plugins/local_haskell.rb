module LocalHaskell
  include CommandLinePlugin

  def run_test_command(file)
    "runhaskell #{file.path} 2>&1"
  end
end
