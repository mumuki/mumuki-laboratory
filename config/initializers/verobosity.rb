module Verbosity

  module Verbose
    def self.visible_expectation_results(expectation_results)
      expectation_results
    end

    def render_feedback?(feedback)
      feedback.present?
    end
  end

  module Standard
    def self.visible_expectation_results(expectation_results)
      expectation_results.select { |it| it[:result] == :failed }
    end

    def render_feedback?(feedback)
      feedback.present?
    end
  end

  module Silent
    def self.visible_expectation_results(expectation_results)
      []
    end

    def render_feedback?(feedback)
      false
    end
  end

end
