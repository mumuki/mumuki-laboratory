module WithCustomAssets
  def theme_stylesheet_url
    Organization.current.theme_stylesheet_url
  end

  def extension_javascript_url
    Organization.current.extension_javascript_url
  end

end
