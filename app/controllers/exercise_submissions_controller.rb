class ExerciseSubmissionsController < ApplicationController
  before_action :set_submission, only: [:show]
  before_action :set_exercise, only: [:create, :new, :show, :index]
  before_action :set_previous_submission_content, only: [:new]
  before_filter :authenticate!

  def index
    @submissions = paginated @exercise.submissions
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

  def set_previous_submission_content
    if @exercise.submissions
      @previous_submission_content = @exercise.submissions.select {|s| s.submitter_id == current_user.id }.last.content
    else
      @previous_submission_content = ""
    end
  end

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end

  def submission_params
    params.require(:submission).permit(:content).merge(exercise: @exercise)
  end
end
