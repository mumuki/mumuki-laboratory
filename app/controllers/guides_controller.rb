class GuidesController < ApplicationController
  def show
    #FIXME use mumukit slug
    redirect_to Guide.find_by(slug: "#{params[:organization]}/#{params[:repository]}").usage_in_organization
  end
end