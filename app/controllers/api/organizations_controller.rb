module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    before_action :authorize_janitor!, only: [:show, :index]
    before_action :authorize_admin!, only: [:update, :create]

    def index
      render json: { organizations: Organization.accessible_as(current_user, :janitor) }
    end

    def show
      render json: @organization.to_resource_h
    end

    def create
      @organization.save!
      render json: @organization.to_resource_h
    end

    def update
      @organization.update! organization_params
      render json: @organization.to_resource_h
    end
  end

end
