class GuideImportsController < ApplicationController
  before_action :set_guide

  def create
    @guide.imports.create!
    redirect_to @guide, notice: t(:import_created)
  end

  private

  def set_guide
    @guide = Guide.find(params[:guide_id])
  end
end