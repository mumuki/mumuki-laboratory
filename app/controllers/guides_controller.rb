class GuidesController < ApplicationController
  def show
    redirect_to_usage Guide.find_by!(id: params[:id])
  end

  def show_transparently
    redirect_to_usage Guide.find_transparently!(params)
  end
end
