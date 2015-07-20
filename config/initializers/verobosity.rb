module Verbosity

  module Verbose
    def self.visible_expectation_results(expectation_results)
      expectation_results
    end
  end

  module Standard
    def self.visible_expectation_results(expectation_results)
      expectation_results.select { |it| it[:result] == :failed }
    end
  end

  module Silent
    def self.visible_expectation_results(expectation_results)
      []
    end
  end

end
