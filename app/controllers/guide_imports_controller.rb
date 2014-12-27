class GuideImportsController < ApplicationController
  before_action :set_guide

  skip_before_filter :verify_authenticity_token

  respond_to :json, :html

  def create
    @import = @guide.imports.create!
    flash[:notice] = t(:import_created)
    respond_with @import, location: @guide
  end

  private

  def set_guide
    @guide = Guide.find(params[:guide_id])
  end
end