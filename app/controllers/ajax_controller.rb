class AjaxController < ApplicationController
  before_action :authenticate!

  private

  def authenticate!
    head 403 unless current_user?
  end
end
