class HomeController < ApplicationController

  before_action :redirect_to_last_guide

  def index
  end

  private

  def redirect_to_last_guide
    redirect_to current_user.last_guide if visitor_recurrent?
  end

  def visitor_recurrent?
    current_user? && current_user.last_guide.present? && visitor_comes_from_internet?
  end

  def visitor_comes_from_internet?
    !Addressable::URI.parse(request.referer).host.include? 'mumuki' rescue true
  end
end
