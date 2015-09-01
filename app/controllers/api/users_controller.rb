class Api::UsersController < Api::BaseController
  def index
    @users = User.all
    @users = @users.where(id: params[:ids]) if params[:ids]
    @users = @users.where(email: params[:emails]) if params[:emails]
    render json: {users: @users.as_json(only: [:id, :name, :email, :image_url])}
  end
end