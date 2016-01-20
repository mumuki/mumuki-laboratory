module WithStatusRendering
  def class_for_status(s)
    Status.coerce(s).iconize[:class].to_s
  end

  def icon_type_for_status(s)
    Status.coerce(s).iconize[:type].to_s
  end
end