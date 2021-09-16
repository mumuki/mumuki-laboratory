class AjaxController < ApplicationController
  before_action :authenticate!
  before_action :validate_organization_enabled!, on: :create

  private

  def authenticate!
    head 403 unless current_user?
  end

  def validate_organization_enabled!
    Organization.current.validate_enabled! unless current_user&.teacher_here?
  end
end
