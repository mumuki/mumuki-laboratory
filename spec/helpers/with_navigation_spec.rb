require 'spec_helper'

describe WithStudentPathNavigation, organization_workspace: :test do
  helper WithStudentPathNavigation
  helper FontAwesome::Rails::IconHelper

  describe '#next_button' do
    context 'with problems' do
      let(:lesson) { create(:lesson, name: 'my guide', exercises: [
        create(:exercise, id: 11, name: 'exercise 1'),
        create(:exercise, id: 12, name: 'exercise 2'),
        create(:exercise, id: 13, name: 'exercise 3')
      ]) }

      let!(:exercise_1) { lesson.exercises.first }
      let!(:exercise_2) { lesson.exercises.second }
      let!(:exercise_3) { lesson.exercises.third }

      let(:current_user) { create(:user) }

      context 'when user did not submit any solution' do
        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/12-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/13-exercise-3\">Next: exercise 3 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/11-exercise-1\">Next pending: exercise 1 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when on last unresolved exercise' do
        before do
          exercise_1.submit_solution!(current_user).passed!
          exercise_3.submit_solution!(current_user).passed!
        end

        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/12-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to be nil }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/12-exercise-2\">Next pending: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when user did submit a solution' do
        before do
          exercise_1.submit_solution!(current_user).passed!
        end

        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/12-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/13-exercise-3\">Next: exercise 3 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/12-exercise-2\">Next pending: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
      end
    end

    context 'with non-terminal readings' do
      let(:lesson) { create(:lesson, name: 'my guide', exercises: [
        create(:reading, id: 11, name: 'exercise 1'),
        create(:exercise, id: 12, name: 'exercise 2')
      ]) }

      let!(:reading) { lesson.exercises.first }
      let!(:exercise) { lesson.exercises.second }

      let(:current_user) { create(:user) }

      context 'when user did not submit any exercise' do
        it { expect(next_button(reading)).to eq "<a class=\"btn-confirmation btn btn-success btn-block\" data-confirmation-url=\"/exercises/11-exercise-1/confirmations\" role=\"button\" href=\"/exercises/12-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/11-exercise-1\">Next pending: exercise 1 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when user finished just reading' do
        before do
          reading.submit_confirmation!(current_user)
        end

        it { expect(next_button(reading)).to eq "<a class=\"btn-confirmation btn btn-success btn-block\" data-confirmation-url=\"/exercises/11-exercise-1/confirmations\" role=\"button\" href=\"/exercises/12-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise)).to eq nil }
      end
    end


    context 'with guides' do
      let!(:current_user) { create(:user) }

      context 'when guide has no suggestions' do
        let(:exercise) { build(:exercise) }
        let(:lesson) { create(:lesson, name: 'Guide A', exercises: [exercise]) }
        let(:chapter) { create(:chapter, lessons: [lesson]) }

        before { reindex_current_organization! }
        before { exercise.submit_solution!(current_user).passed! }

        it { expect(next_button(lesson)).to be nil }
      end

      context 'when guide has one suggestion' do
        let!(:suggested_lesson) { create(:lesson, name: 'l3') }
        let!(:lesson) { create(:lesson, name: 'l2') }
        let!(:another_lesson) { create(:lesson, name: 'l1') }
        let!(:chapter) { create(:chapter, lessons: [another_lesson, lesson, suggested_lesson]) }

        before { reindex_current_organization! }

        it { expect(next_button(lesson)).to include "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/lessons/#{suggested_lesson.friendly_name}\">Next: #{suggested_lesson.name} <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when guide has many suggestions' do
        let!(:suggested_lesson_1) { create(:lesson) }
        let!(:suggested_lesson_2) { create(:lesson) }
        let!(:lesson) { create(:lesson) }
        let!(:chapter) { create(:chapter, lessons: [lesson, suggested_lesson_1, suggested_lesson_2]) }

        before { reindex_current_organization! }

        it { expect(next_button(lesson)).to include "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/lessons/#{suggested_lesson_1.friendly_name}\">Next: #{suggested_lesson_1.name} <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(lesson)).to be_html_safe }
      end
    end
  end

end
