class ExerciseReposController < ApplicationController

  before_filter :authenticate!

  def new
    @repo = ExerciseRepo.new
  end

  def create
    @repo = ExerciseRepo.new(repo_parms.merge(author: current_user))
    if @repo.save
      redirect_to @repo, notice: 'Repository created successfully'
    else
      render :new
    end
  end

  def show
    @repo = ExerciseRepo.find(params[:id])
  end

  private

  def repo_parms
    params.require(:exercise_repo).permit(:github_url, :name)
  end
end