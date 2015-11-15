require 'addressable/uri'

class HomeController < ApplicationController
  before_action :redirect_to_last_guide

  def index
  end

  private

  def redirect_to_last_guide
    redirect_to current_user.last_guide, notice: t(:welcome_back_after_redirection) if visitor_recurrent?
  end

  def visitor_recurrent?
    current_user? && current_user.last_guide.present? && visitor_comes_from_internet?
  end

  def visitor_comes_from_internet?
    !request_host_include? %w(mumuki localhost)
  end

  def request_host_include?(hosts)
    hosts.any? { |host| Addressable::URI.parse(request.referer).host.include? host } rescue false
  end


end
