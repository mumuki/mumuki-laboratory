module MonoLessonHelper

  def render_if_mono_lesson(options)
    if @chapter.mono_lesson?
      render options
    else
      yield if block_given?
    end
  end

end
