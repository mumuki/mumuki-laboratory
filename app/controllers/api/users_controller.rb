class Api::UsersController < Api::BaseController
  def index
    @users = User.all
    @users = @users.where(id: params[:users]) if params[:users]
    render json: {users: @users.as_json(only: [:id, :name, :email])}
  end
end
