module Api
  class CoursesController < BaseController
    before_action :set_new_course!, only: :create
    before_action :authorize_janitor!, only: :create

    def create
      @course.save!
      render json: @course
    end

    private

    def course_params
      params.require(:course).permit(:slug, :code, :period, :description, shifts: [], days: [])
    end

    def set_new_course!
      @course = Course.new course_params
    end

    def authorization_slug
      @course.slug
    end
  end
end
