class GuideExportsController < ApplicationController
  include NestedInGuide

  respond_to :json, :html

  before_action :authenticate!

  def create
    @import = @guide.exports.create!(committer: current_user)
    flash[:notice] = t(:export_created)
    respond_with @import, location: @guide
  end
end
