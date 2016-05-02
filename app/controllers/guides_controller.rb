class GuidesController < ApplicationController
  def show
    redirect_to Guide.find_by(slug: "#{params[:organization]}/#{params[:repository]}").lesson #FIXME
  end
end