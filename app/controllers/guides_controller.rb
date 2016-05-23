class GuidesController < ApplicationController
  def show
    redirect_to_usage Guide.find_by(id: params[:id])
  end

  def show_by_slug
    #FIXME use mumukit slug
    redirect_to_usage Guide.find_by(slug: "#{params[:organization]}/#{params[:repository]}")
  end

  def redirect_to_usage(guide)
    guide.try(:usage_in_organization).try { |usage| redirect_to usage } || render_not_found
  end

  def index
    @q = params[:q]
    @items = paginated Guide.by_full_text(@q).map { |it| it.usage_in_organization }.compact
  end

end