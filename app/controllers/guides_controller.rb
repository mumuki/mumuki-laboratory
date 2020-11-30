class GuidesController < ApplicationController
  include Mumuki::Laboratory::Controllers::ImmersiveNavigation

  def show
    redirect_to_usage Guide.find_by!(id: params[:id])
  end

  def show_transparently
    redirect_to_usage Guide.find_transparently!(params)
  end
end
