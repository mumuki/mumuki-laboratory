module StatusRenderingVerbosity
  extend ConfigurableGlobal

  def self.get_current
    "StatusRenderingVerbosity::#{Rails.configuration.status_rendering_verbosity.capitalize}".constantize
  end

  module Verbose
    def self.visible_expectation_results(_status, expectation_results)
      expectation_results
    end

    def self.render_feedback?(feedback)
      feedback.present?
    end
  end

  module Standard
    def self.visible_expectation_results(status, expectation_results)
      if status.errored?
        []
      else
        expectation_results.select { |it| it[:result] == :failed }
      end
    end

    def self.render_feedback?(feedback)
      feedback.present?
    end
  end

  module Silent
    def self.visible_expectation_results(_status, _expectation_results)
      []
    end

    def self.render_feedback?(_feedback)
      false
    end
  end

end
