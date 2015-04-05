class GuideExportsController < ApplicationController
  include NestedInGuide

  def create
    @import = @guide.imports.create!
    flash[:notice] = t(:import_created)

    respond_with @import, location: @guide
  end
end
