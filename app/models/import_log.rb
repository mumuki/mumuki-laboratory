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

  def no_test(name)
    @messages << "There must be exactly 1 test file for #{name}"
  end

  def to_s
    @messages.join(', ')
  end
end
