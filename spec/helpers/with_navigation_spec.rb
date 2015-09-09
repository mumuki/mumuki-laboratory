require 'spec_helper'

describe WithNavigation do
  helper WithNavigation
  helper FontAwesome::Rails::IconHelper

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
    it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-2-exercise-2\">Next <i class=\"fa fa-chevron-right\"></i></a>" }
    it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-3-exercise-3\">Next <i class=\"fa fa-chevron-right\"></i></a>" }
    it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning\" href=\"/exercises/my-guide-1-exercise-1\"><i class=\"fa fa-repeat\"></i> Finish pending</a>" }
  end

  context 'when user did submit a solution' do
    before do
      exercise_1.submit_solution(current_user, status: :passed)
    end

    it { expect(next_button(exercise_1)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-2-exercise-2\">Next <i class=\"fa fa-chevron-right\"></i></a>" }
    it { expect(next_button(exercise_2)).to eq "<a class=\"btn btn-success\" href=\"/exercises/my-guide-3-exercise-3\">Next <i class=\"fa fa-chevron-right\"></i></a>" }
    it { expect(next_button(exercise_3)).to eq "<a class=\"btn btn-warning\" href=\"/exercises/my-guide-2-exercise-2\"><i class=\"fa fa-repeat\"></i> Finish pending</a>" }
  end


end