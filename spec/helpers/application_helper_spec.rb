require 'spec_helper'

describe ApplicationHelper, organization_workspace: :test do
  helper ApplicationHelper
  helper LinksHelper

  describe '#link_to_exercise' do
    let(:exercise) { lesson.exercises.third }
    let(:lesson) {
      create(:lesson, name: 'bar', exercises: [
          create(:exercise, name: 'foo2', id: 10),
          create(:exercise, name: 'foo2', id: 20),
          create(:exercise, name: 'foo3', id: 30)
      ]) }
    let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }

    before { reindex_current_organization! }

    it { expect(link_to_path_element(exercise, mode: :plain)).to eq '<a href="/exercises/30-c1-bar-foo3">foo3</a>' }
    it { expect(link_to_path_element(exercise, mode: :friendly)).to eq '<a href="/exercises/30-c1-bar-foo3">C1: bar - foo3</a>' }
    it { expect(link_to_path_element(exercise)).to eq '<a href="/exercises/30-c1-bar-foo3">3. foo3</a>' }
  end

  describe '#link_to_guide' do
    let(:lesson) { create(:lesson, id: 1, name: 'foo') }
    it { expect(link_to_path_element(lesson)).to start_with '<a href="/lessons/1-foo">foo' }
  end

  describe 'bibliotheca links' do
    let(:current_user) { create(:user) }
    let(:lesson) { create(:lesson, id: 1, name: 'foo') }
    let(:guide) { lesson.guide }

    before { current_user.make_editor_of! guide.slug  }

    it { expect(url_for_bibliotheca_guide(guide)).to start_with 'http://bibliotheca.localmumuki.io/#/guides/mumuki/mumuki-test-lesson' }
  end

end
