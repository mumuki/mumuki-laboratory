class GuidesController < ApplicationController
  def show
    redirect_to_usage Guide.find_by(id: params[:id])
  end

  def show_by_slug
    #FIXME use mumukit slug
    redirect_to_usage Guide.find_by(slug: "#{params[:organization]}/#{params[:repository]}")
  end

  def redirect_to_usage(guide)
    redirect_to guide.usage_in_organization
  end

  def index
    @q = params[:q]
    @items = paginated Guide.by_full_text(@q).map { |it| it.usage_in_organization }.compact
  end

end