class OrganizationController < ApplicationController

  def show
    @exams = Organization.current.accessible_exams_for current_user
  end
end
