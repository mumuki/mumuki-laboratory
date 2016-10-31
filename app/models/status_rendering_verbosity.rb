module StatusRenderingVerbosity
  extend ConfigurableGlobal

  def self.get_current
    "StatusRenderingVerbosity::#{Rails.configuration.status_rendering_verbosity.capitalize}".constantize
  end

  module Verbose
    def self.visible_expectation_results(expectation_results)
      expectation_results
    end

    def self.render_feedback?(feedback)
      feedback.present?
    end
  end

  module Standard
    def self.visible_expectation_results(expectation_results)
      expectation_results.select { |it| it[:result] == :failed }
    end

    def self.render_feedback?(feedback)
      feedback.present?
    end
  end

  module Silent
    def self.visible_expectation_results(expectation_results)
      []
    end

    def self.render_feedback?(feedback)
      false
    end
  end

end
