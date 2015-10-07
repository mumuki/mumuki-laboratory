class ImportLog
  attr_accessor :messages

  def initialize
    @messages = []
  end
  def no_description(name)
    @messages << "Description does not exist for #{name}"
  end

  def no_meta(name)
    @messages << "Meta does not exist for #{name}"
  end

  def saved(exercise)
    if exercise.errors.present?
      exercise.errors.full_messages.each do |message|
        @messages << "Saving #{exercise.name} produced #{message}"
      end
    end
  end

  def to_s
    @messages.join(', ')
  end
end
