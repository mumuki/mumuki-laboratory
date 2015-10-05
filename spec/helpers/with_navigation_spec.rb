require 'spec_helper'

describe WithNavigation do
  helper WithNavigation
  helper FontAwesome::Rails::IconHelper

  before { I18n.locale = :en }

  describe '#next_button' do
    context 'with exercises' do
      let(:guide) { create(:guide, name: 'my-guide') }
      let!(:exercise_1) { create(:exercise, guide: guide, position: 1, name: 'exercise 1') }
      let!(:exercise_2) { create(:exercise, guide: guide, position: 2, name: 'exercise 2') }
      let!(:exercise_3) { create(:exercise, guide: guide, position: 3, name: 'exercise 3') }
      let(:current_user) { create(:user) }


      it { expect(next_nav_button(exercise_1)).to eq "<a class=\"text-info\" href=\"/exercises/my-guide-2-exercise-2\">Next <i class=\"fa fa-chevron-circle-right\"></i></a>" }
      it { expect(next_nav_button(exercise_2)).to eq "<a class=\"text-info\" href=\"/exercises/my-guide-3-exercise-3\">Next <i class=\"fa fa-chevron-circle-right\"></i></a>" }
      it { expect(next_nav_button(exercise_3)).to eq nil }

      it { expect(previous_nav_button(exercise_1)).to eq nil }
      it { expect(previous_nav_button(exercise_2)).to eq "<a class=\"text-info\" href=\"/exercises/my-guide-1-exercise-1\"><i class=\"fa fa-chevron-circle-left\"></i> Previous</a>" }
      it { expect(previous_nav_button(exercise_3)).to eq "<a class=\"text-info\" href=\"/exercises/my-guide-2-exercise-2\"><i class=\"fa fa-chevron-circle-left\"></i> Previous</a>" }

      context 'when user did not submit any solution' do
        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-2-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-3-exercise-3\">Next: exercise 3 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning\" href=\"/exercises/my-guide-1-exercise-1\">Next pending: exercise 1 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when on last unresolved exercise' do
        before do
          exercise_1.submit_solution(current_user).passed!
          exercise_3.submit_solution(current_user).passed!
        end

        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-2-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to be nil }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning\" href=\"/exercises/my-guide-2-exercise-2\">Next pending: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when user did submit a solution' do
        before do
          exercise_1.submit_solution(current_user).passed!
        end

        it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-2-exercise-2\">Next: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-3-exercise-3\">Next: exercise 3 <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning\" href=\"/exercises/my-guide-2-exercise-2\">Next pending: exercise 2 <i class=\"fa fa-chevron-right\"></i></a>" }
      end
    end

    context 'with guides' do
      let(:path) { create(:path) }
      let!(:current_user) { create(:user) }

      context 'when guide has no suggestions' do
        let(:guide) { create(:guide, position: 1, path: path, name: 'Guide A') }
        let(:exercise) { create(:exercise, position: 1, guide: guide) }

        before { exercise.submit_solution(current_user).passed! }

        it { expect(next_button(guide)).to be nil }
      end

      context 'when guide has one suggestion' do
        let!(:suggested_guide) { create(:guide, position: 2, path: path) }
        let(:guide) { create(:guide, position: 1, path: path) }
        it { expect(next_button(guide)).to include "<a class=\"btn btn-success\" href=\"/guides/#{suggested_guide.slug}\">Next: #{suggested_guide.name} <i class=\"fa fa-chevron-right\"></i></a>" }
      end

      context 'when guide has many suggestions' do
        let!(:suggested_guide_1) { create(:guide, position: 2, path: path) }
        let!(:suggested_guide_2) { create(:guide, position: 2, path: path) }
        let(:guide) { create(:guide, position: 1, path: path) }

        it { expect(next_button(guide)).to include "<a class=\"btn btn-success\" href=\"/guides/#{suggested_guide_1.slug}\">Next: #{suggested_guide_1.name} <i class=\"fa fa-chevron-right\"></i></a>" }
        it { expect(next_button(guide)).to be_html_safe }
      end
    end
  end

end
