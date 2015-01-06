module WithExerciseIndex

  def index
    @exercises  = paginated exercises.by_tag params[:tag]
    render 'exercises/index'
  end

end
