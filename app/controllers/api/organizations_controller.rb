module Api
  class OrganizationsController < BaseController
    include OrganizationsControllerTemplate

    before_action :authorize_admin!

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

    def authorization_slug
      '_/_'
    end
  end

end
