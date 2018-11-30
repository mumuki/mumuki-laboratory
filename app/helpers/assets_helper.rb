module AssetsHelper
  def assets_include_tags
    %Q{
      <meta name="turbolinks-cache-control" content="no-cache">
      #{stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'}
      #{javascript_include_tag 'application', 'data-turbolinks-track': 'reload'}
      <link rel="icon" type="image/x-icon" href="#{Organization.current.favicon_url}" data-turbolinks-track="reload">
      <link rel="stylesheet" type="text/css" href="#{theme_stylesheet_url}" data-turbolinks-track="reload">
      <script type="text/javascript" src="#{extension_javascript_url}" defer data-turbolinks-track="reload"></script>
    }.html_safe
  end
end
