class GuideExportsController < ApplicationController
  include NestedInGuide

  def create
    @import = @guide.exports.create!
    flash[:notice] = t(:export_created)

    respond_with @guide
  end
end
