module AssetsHelper
  def assets_include_tags
    %Q{
      <meta name="turbolinks-cache-control" content="no-cache">
      #{laboratory_assets_include_tags}
      #{organization_assets_include_tags}
    }.html_safe
  end

  def laboratory_assets_include_tags
    %Q{
      #{stylesheet_link_tag 'mumuki_laboratory/application', media: 'all', 'data-turbolinks-track': 'reload'}
      #{javascript_include_tag 'mumuki_laboratory/application.js', 'data-turbolinks-track': 'reload'}
    }
  end

  def organization_assets_include_tags
    %Q{
      <link rel="icon" type="image/x-icon" href="#{Organization.current.favicon_url}" data-turbolinks-track="reload">
      <link rel="stylesheet" type="text/css" href="#{theme_stylesheet_url}" data-turbolinks-track="reload">
      <script type="text/javascript" src="#{extension_javascript_url}" defer data-turbolinks-track="reload"></script>
    }
  end
end
