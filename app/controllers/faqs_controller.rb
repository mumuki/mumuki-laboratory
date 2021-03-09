class FAQsController < ApplicationController
  def index
    @faqs = Organization.current.faqs_html
    raise Mumuki::Domain::NotFoundError unless @faqs.present?
  end
end
