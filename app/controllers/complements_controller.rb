class ComplementsController < GuideContainerController

  private

  def subject
    @complement ||= Complement.find_by(id: params[:id])
  end
end
