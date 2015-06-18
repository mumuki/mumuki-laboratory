class ExerciseSubmissionsController < ApplicationController
  before_action :authenticate!

  before_action :set_submission, only: [:show, :status, :results]
  before_action :set_exercise, only: [:create, :show, :index, :results]
  before_action :set_guide, only: [:show, :results]

  def index
    @submissions = paginated @exercise.submissions_for(current_user).order(created_at: :desc)
  end

  def show
  end

  def create
    @submission = current_user.submissions.build(submission_params)
    @submission.save!
    @submission.run_tests!
    render partial: 'exercise_submissions/results', locals: {submission: @submission}
  end

  private

  def set_guide
    @guide = @exercise.guide
  end

  def set_submission
    @submission = Submission.find(params[:id] || params[:submission_id])
  end

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end

  def submission_params
    params.require(:submission).permit(:content).merge(exercise: @exercise)
  end
end
