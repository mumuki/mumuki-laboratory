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
    let(:exercise) { create(:exercise, name: 'my exercise', guide: guide, number: 1) }
    let(:guide) { create(:guide, name: 'my guide') }

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my guide') }
    it { expect(breadcrumb).to be_html_safe }
  end

  context 'exercise in chapter' do
    let!(:chapter) { create(:chapter, name: 'my chapter', lessons: [lesson]) }
    let(:lesson) { create(:lesson, name: 'my lesson', exercises: [exercise]) }
    let(:exercise) { create(:exercise, name: 'my exercise') }

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my lesson') }
    it { expect(breadcrumb).to include('my chapter') }
    it { expect(breadcrumb).to be_html_safe }

  end
end
