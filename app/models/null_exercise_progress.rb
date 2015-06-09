module NullExerciseProgress
  class << self
    def content
      ''
    end

    def solved?
      false
    end

    def last_submission
      nil
    end

    def last_submission_date
      nil
    end

    def status
      :unknown
    end
  end
end
