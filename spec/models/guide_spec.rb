require 'spec_helper'

describe Guide do
  let!(:extra_user) { create(:user, name: 'ignatiusReilly') }
  let(:guide) { create(:guide) }

  describe '#clear_progress!' do
    let(:student) { create :user }
    let(:more_clauses) { create(:exercise, name: 'More Clauses') }

    before { more_clauses.submit_solution! student, content: 'foo(X) :- not(bar(X))' }

    before { guide.clear_progress!(student) }

    it { expect(student.reload.assignments).to be_empty }
  end

  describe '#submission_contents_for' do
    before do
      guide.exercises = [create(:exercise, language: guide.language), create(:exercise, language: guide.language)]
      guide.save!
    end
  end
end
