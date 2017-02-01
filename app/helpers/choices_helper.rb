module ChoicesHelper
  def checked?(choice, content)
    content.split(':').include? choice.index.to_s
  end
end
