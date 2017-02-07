require 'spec_helper'

describe BreadcrumbsHelper do

  helper BreadcrumbsHelper
  helper LinksHelper

  let(:breadcrumb) { breadcrumbs(exercise) }

  context 'exercise in complement' do
    let!(:complement) { create(:complement, name: 'my guide', exercises: [
        create(:exercise, name: 'my exercise')
    ]) }
    let(:exercise) { complement.exercises.first }

    before { reindex_current_organization! }

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my guide') }
    it { expect(breadcrumb).to be_html_safe }
  end

  context 'exercise in chapter' do
    let!(:chapter) { create(:chapter, name: 'my chapter', lessons: [
        create(:lesson, name: 'my lesson', exercises: [
            create(:exercise, name: 'my exercise')
        ])
    ]) }
    let(:exercise) { chapter.first_lesson.exercises.first }

    before { reindex_current_organization! }

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my lesson') }
    it { expect(breadcrumb).to include('my chapter') }
    it { expect(breadcrumb).to be_html_safe }
  end
end
