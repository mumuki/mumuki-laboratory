class GuidesController < ApplicationController
  def show
    redirect_to_usage Guide.find_by!(id: params[:id])
  end

  def show_transparently
    redirect_to_usage Guide.find_transparently!(params)
  end

  def redirect_to_usage(guide)
    raise Mumuki::Domain::NotFoundError unless guide.usage_in_organization.try { |usage| redirect_to usage }
  end
end
