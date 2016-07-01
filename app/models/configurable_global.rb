module ConfigurableGlobal
  def current
    @current ||= get_current
  end

  def method_missing(name, *args, &block)
    current.send name, *args, &block
  end
end