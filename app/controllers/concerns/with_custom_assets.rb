module WithCustomAssets
  def theme_stylesheet_url
    Organization.theme_stylesheet_url
  end

  def extension_javascript_url
    Organization.extension_javascript_url
  end
end
