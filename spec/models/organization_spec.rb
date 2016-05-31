require 'spec_helper'

describe Organization do
  let(:organization) { Organization.find_by(name: 'test') }
  let(:user) { create(:user) }

  it { expect(organization).to_not be nil }
  it { expect(organization.slug).to eq 'test/atheneum' }
  it { expect(organization).to eq Organization.current }

  describe '#notify_recent_assignments!' do
    it { expect { organization.notify_recent_assignments! 1.minute.ago }.to_not raise_error }
  end

  describe '#notify_assignments_by!' do
    it { expect { organization.notify_assignments_by! user }.to_not raise_error }
  end

  describe '#in_path?' do
    let!(:chapter_in_path) { create(:chapter, lessons: [
        create(:lesson, exercises: [
            create(:exercise),
            create(:exercise)
        ]),
        create(:lesson)
    ]) }
    let(:topic_in_path) { chapter_in_path.lessons.first }
    let(:topic_in_path) { chapter_in_path.topic }
    let(:lesson_in_path) { chapter_in_path.lessons.first }
    let(:guide_in_path) { lesson_in_path.guide }
    let(:exercise_in_path) { lesson_in_path.exercises.first }

    let!(:orphan_exercise) { create(:exercise) }
    let!(:orphan_guide) { orphan_exercise.guide }

    before { reindex_current_organization! }

    it { expect(Organization.current.in_path? orphan_guide).to be false }
    it { expect(Organization.current.in_path? orphan_exercise).to be false }

    it { expect(Organization.current.in_path? chapter_in_path).to be true }
    it { expect(Organization.current.in_path? topic_in_path).to be true }
    it { expect(Organization.current.in_path? lesson_in_path).to be true }
    it { expect(Organization.current.in_path? guide_in_path).to be true }
    pending { expect(Organization.current.in_path? exercise_in_path).to be true }
  end

end
