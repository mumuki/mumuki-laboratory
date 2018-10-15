module FriendlyName

  def to_param
    friendly_name
  end

  def friendly_name
    "#{id} #{friendly}".friendlish
  end
end
