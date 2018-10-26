require 'spec_helper'

describe BreadcrumbsHelper, organization_workspace: :test do

  helper BreadcrumbsHelper
  helper LinksHelper
  helper ERB::Util

  context 'user' do
    let(:user) { create(:user) }
    let(:breadcrumb) { breadcrumbs(user) }

    it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>#{user.name}</li>" }
  end

  context 'exercise' do
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

      it { expect(breadcrumb).to include "<a href=\"/complements/#{complement.id}-my-guide\">my guide</a>" }
      it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>1. my exercise</li>" }
    end

    context 'exercise in chapter' do
      let!(:chapter) { create(:chapter, name: 'my chapter', lessons: [lesson]) }
      let(:lesson) { create(:lesson, name: 'my lesson', exercises: [exercise]) }
      let(:exercise) { create(:exercise, name: 'my exercise') }

      before { reindex_current_organization! }

      it { expect(breadcrumb).to include('my exercise') }
      it { expect(breadcrumb).to include('my lesson') }
      it { expect(breadcrumb).to include('my chapter') }
      it { expect(breadcrumb).to be_html_safe }

      it { expect(breadcrumb).to include "<a href=\"/chapters/#{chapter.id}-my-chapter\">my chapter</a>" }
      it { expect(breadcrumb).to include "<a href=\"/lessons/#{lesson.id}-my-chapter-my-lesson\">1. my lesson</a>" }
      it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>1. my exercise</li>" }
    end
  end
end
