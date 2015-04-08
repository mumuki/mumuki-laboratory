class GuideExportsController < ApplicationController
  include NestedInGuide

  before_action :authenticate!

  def create
    @import = @guide.exports.create!(committer: current_user)
    flash[:notice] = t(:export_created)

    respond_with @guide
  end
end
