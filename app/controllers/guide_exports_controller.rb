class GuideExportsController < ApplicationController
  include NestedInGuide

  respond_to :json, :html

  before_action :authenticate!

  def create
    if current_user.can_commit?(@guide)
      @import = @guide.exports.create!(committer: current_user)
      flash[:notice] = t(:export_created)
    else
      flash[:notice] = t(:export_created)
    end
    respond_with @guide
  end
end
