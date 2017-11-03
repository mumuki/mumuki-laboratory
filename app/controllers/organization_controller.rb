class OrganizationController < ApplicationController

  def show
    @organization = Organization.current
    @exams = Organization.current.accessible_exams_for current_user
  end
end
