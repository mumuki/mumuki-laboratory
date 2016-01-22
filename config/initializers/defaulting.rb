class Object
  def defaulting(value, &block)
    try(&block) || value
  end
end