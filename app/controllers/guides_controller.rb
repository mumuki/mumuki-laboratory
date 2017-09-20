class GuidesController < ApplicationController
  def show
    redirect_to_usage Guide.find_by!(id: params[:id])
  end

  def show_by_slug
    redirect_to_usage Guide.by_slug_parts!(params)
  end

  def redirect_to_usage(guide)
    raise Exceptions::NotFoundError unless guide.usage_in_organization.try { |usage| redirect_to usage }
  end
end
