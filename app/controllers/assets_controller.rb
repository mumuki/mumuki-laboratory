class AssetsController < ApplicationController

  skip_before_action :verify_authenticity_token, :authorize_if_private!

  def theme_stylesheet
    render inline: Organization.current.theme_stylesheet.to_s, content_type: 'text/css'
  end

  def extension_javascript
    render inline: Organization.current.extension_javascript.to_s, content_type: 'text/javascript'
  end

end
