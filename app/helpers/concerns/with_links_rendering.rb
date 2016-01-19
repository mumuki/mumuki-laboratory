module WithLinksRendering

  def link_to_path_element(element, options={})
    name = extract_name element, options
    link_to name, element, options
  end

  def link_to_user(user)
    link_to user.name, user
  end

  private

  def extract_name(named, options)
    case options.delete(:mode)
      when :plain
        named.name
      when :friendly
        named.friendly
      else
        named.contextualized_name
    end
  end
end
