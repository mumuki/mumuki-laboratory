class ImportLog
  attr_accessor :messages

  def initialize
    @messages = []
  end
  def no_description(title)
    @messages << "Description does not exist for #{title}"
  end

  def no_meta(title)
    @messages << "Meta does not exist for #{title}"
  end

  def no_test(title)
    @messages << "There must be exactly 1 test file for #{title}"
  end

  def to_s
    @messages.join(', ')
  end
end
