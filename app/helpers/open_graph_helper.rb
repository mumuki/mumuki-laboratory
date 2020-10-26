module OpenGraphHelper
  def open_graph_tags(subject)
    %Q{
      <meta property="og:site_name" content="#{Organization.current.display_name}" />
      <meta property="og:title" content="#{h page_title(subject)}"/>
      <meta property="og:description" content="#{Organization.current.description}"/>
      <meta property="og:type" content="website"/>
      <meta property="og:image" content="#{Organization.current.open_graph_image_url}"/>
      <meta property="og:url" content="#{request.original_url}"/>
    }.html_safe
  end
end
