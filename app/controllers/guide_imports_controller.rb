class GuideImportsController < ApplicationController
  include NestedInGuide

  skip_before_filter :verify_authenticity_token

  respond_to :json, :html

  def create
    @import = @guide.imports.create!
    flash[:notice] = t(:import_created)
    respond_with @import, location: @guide
  end
end
