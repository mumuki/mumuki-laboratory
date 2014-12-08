class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show]
  before_action :set_exercise, only: [:create, :new, :show, :index]
  before_filter :authenticate!

  def index
    @submissions = @exercise.submissions
  end

  def show
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = current_user.submissions.build(submission_params)

    if @submission.save
      redirect_to [@exercise, @submission], notice: 'Submission was successfully created.'
    else
      render :new
    end
  end

  private
  def set_submission
    @submission = Submission.find(params[:id])
  end

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end

  def submission_params
    params.require(:submission).permit(:content).merge(exercise: @exercise)
  end
end
