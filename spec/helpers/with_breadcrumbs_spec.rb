require 'spec_helper'

describe WithBreadcrumbs do

  helper WithBreadcrumbs
  helper WithLinksRendering

  let(:breadcrumb) { exercise_breadcrumb(exercise) }

  context 'standalone exercise' do
    let(:exercise) { create(:exercise, name: 'my exercise') }
    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to be_html_safe }

  end
  context 'exercise in guide' do
    let(:exercise) { create(:exercise, name: 'my exercise', guide: guide, position: 1) }
    let(:guide) { create(:guide, name: 'my guide') }

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my guide') }
    it { expect(breadcrumb).to be_html_safe }
  end

  context 'exercise in chapter' do
    let(:exercise) { create(:exercise, name: 'my exercise', guide: guide, position: 1) }
    let(:guide) { create(:guide, name: 'my guide') }
    let(:chapter) { create(:chapter, name: 'my category') }

    before { chapter.rebuild!([guide]) }

    it { expect(breadcrumb).to include('my exercise') }
    it { expect(breadcrumb).to include('my guide') }
    it { expect(breadcrumb).to include('my category') }
    it { expect(breadcrumb).to be_html_safe }

  end
end
