require 'spec_helper'

describe WithStudentPathNavigation, organization_workspace: :test do
  helper WithStudentPathNavigation
  helper FontAwesome5::Rails::IconHelper

  describe '#next_button' do
    let(:current_user) { create(:user) }
    let(:guide) { create(:indexed_guide) }

    context 'with problems' do
      let!(:exercise_1) { create(:exercise, id: 11, name: 'exercise 1', guide: guide) }
      let!(:exercise_2) { create(:exercise, id: 12, name: 'exercise 2', guide: guide) }
      let!(:exercise_3) { create(:exercise, id: 13, name: 'exercise 3', guide: guide) }

      context 'when user did not submit any solution' do
        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/#{exercise_2.friendly_name}\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/#{exercise_3.friendly_name}\">Next: exercise 3 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/#{exercise_1.friendly_name}\">Next pending: exercise 1 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when on last unresolved exercise' do
        before do
          exercise_1.submit_solution!(current_user).passed!
          exercise_3.submit_solution!(current_user).passed!
        end

        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/#{exercise_2.friendly_name}\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to be nil }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/#{exercise_2.friendly_name}\">Next pending: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when user did submit a solution' do
        before do
          exercise_1.submit_solution!(current_user).passed!
        end

        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/#{exercise_2.friendly_name}\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/exercises/#{exercise_3.friendly_name}\">Next: exercise 3 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/#{exercise_2.friendly_name}\">Next pending: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
      end
    end

    context 'with non-terminal readings' do
      let!(:reading) { create(:reading, id: 11, name: 'exercise 1', guide: guide) }
      let!(:exercise) { create(:exercise, id: 12, name: 'exercise 2', guide: guide) }

      context 'when user did not submit any exercise' do
        it { expect(next_button(reading)).to eq "<a class=\"btn-confirmation btn btn-success btn-block\" data-confirmation-url=\"/exercises/#{reading.friendly_name}/confirmations\" role=\"button\" href=\"/exercises/#{exercise.friendly_name}\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise)).to eq "<a class=\"btn btn-warning btn-block\" role=\"button\" href=\"/exercises/#{reading.friendly_name}\">Next pending: exercise 1 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when user finished just reading' do
        before do
          reading.submit_confirmation!(current_user)
        end

        it { expect(next_button(reading)).to eq "<a class=\"btn-confirmation btn btn-success btn-block\" data-confirmation-url=\"/exercises/#{reading.friendly_name}/confirmations\" role=\"button\" href=\"/exercises/#{exercise.friendly_name}\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise)).to eq nil }
      end
    end

    context 'with guides' do
      let(:lesson_1) { create(:lesson, exercises: create_list(:exercise, 1)) }
      let(:lesson_2) { create(:lesson, exercises: create_list(:exercise, 1)) }
      let(:lesson_3) { create(:lesson, exercises: create_list(:exercise, 1)) }

      context 'when guide has no suggestions' do
        let(:exercise) { create(:exercise, guide: create(:indexed_guide)) }
        let(:lesson) { exercise.guide.lesson }

        before { exercise.submit_solution!(current_user).passed! }

        it { expect(next_button(lesson)).to be nil }
      end

      context 'when guide has' do
        before do
          create(:chapter, lessons: lessons)
          reindex_current_organization!
        end

        let(:lessons) { [lesson_1, lesson_2, lesson_3] }

        context 'one suggestion' do
          it { expect(next_button(lesson_2)).to include "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/lessons/#{lesson_3.friendly_name}\">Next: #{lesson_3.name} <i class=\"fa fa-chevron-right\"></i></a>" }
          it { expect(next_button(lesson_1)).to be_html_safe }
        end

        context 'many suggestions' do
          it { expect(next_button(lesson_1)).to include "<a class=\"btn btn-success btn-block\" role=\"button\" href=\"/lessons/#{lesson_2.friendly_name}\">Next: #{lesson_2.name} <i class=\"fa fa-chevron-right\"></i></a>" }
          it { expect(next_button(lesson_1)).to be_html_safe }
        end
      end
    end
  end
end
