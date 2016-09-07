class GuidesController < ApplicationController
  def show
    redirect_to_usage Guide.find_by!(id: params[:id])
  end

  def show_by_slug
    redirect_to_usage Guide.by_organization_and_repository!(params)
  end

  def redirect_to_usage(guide)
    raise Exceptions::NotFoundError unless guide.usage_in_organization.try { |usage| redirect_to usage }
  end

  def index
    @q = params[:q]
    @items = paginated Guide.by_full_text(@q).map { |it| it.usage_in_organization }.compact
  end

end
