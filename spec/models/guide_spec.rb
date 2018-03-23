require 'spec_helper'

describe Guide do
  let!(:extra_user) { create(:user, first_name: 'Ignatius', last_name: 'Reilly') }
  let(:guide) { create(:guide) }

  describe '#clear_progress!' do
    let(:an_exercise) { create(:exercise) }
    let(:another_exercise) { create(:exercise) }

    before do
      guide.exercises = [an_exercise]
      an_exercise.submit_solution! extra_user
      another_exercise.submit_solution! extra_user
      guide.clear_progress!(extra_user)
    end

    it 'destroys the guides assignments for the given user' do
      expect(an_exercise.assignment_for(extra_user)).to be_nil
    end

    it 'does not destroy other guides assignments' do
      expect(another_exercise.assignment_for(extra_user)).to be_truthy
    end
  end

  describe '#submission_contents_for' do
    before do
      guide.exercises = [create(:exercise, language: guide.language), create(:exercise, language: guide.language)]
      guide.save!
    end
  end
end
