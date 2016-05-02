require 'spec_helper'

describe WithBreadcrumbs do

  helper WithBreadcrumbs
  helper WithLinksRendering

  let(:breadcrumb) { breadcrumbs(exercise) }

  context 'standalone exercise' do
    let(:exercise) { create(:exercise, name: 'my exercise') }
    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to be_html_safe }

  end
  context 'exercise in guide' do
    let(:lesson) { create(:lesson, name: 'my guide', exercises: [
        create(:exercise, name: 'my exercise')
    ]) }
    let(:exercise) { lesson.exercises.first }

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

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my lesson') }
    it { expect(breadcrumb).to include('my chapter') }
    it { expect(breadcrumb).to be_html_safe }

  end
end
