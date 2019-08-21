require 'spec_helper'

describe BreadcrumbsHelper, organization_workspace: :test do

  helper BreadcrumbsHelper
  helper BreadcrumbsOrganizationHelper
  helper LinksHelper
  helper ERB::Util

  let(:home_breadcrumb_with_link) { "<li class='mu-breadcrumb-list-item brand'><a href=\"#{root_path}\">" }
  let(:organization_breadcrumb_with_link) { "<li class='mu-breadcrumb-list-item '><a href=\"#{root_path}\">" }

  context 'user' do
    let(:user) { create(:user, first_name: "Alfonsina", last_name: "Storni") }
    let(:breadcrumb) { breadcrumbs(user) }

    it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>Alfonsina Storni</li>" }
  end

  context 'exercise' do
    let(:breadcrumb) { breadcrumbs(exercise) }

    context 'exercise in complement' do
      let!(:complement) { create(:complement, name: 'my guide', exercises: [
          create(:exercise, name: 'my exercise')
      ]) }
      let(:exercise) { complement.exercises.first }

      before { reindex_current_organization! }

      it { expect(breadcrumb).to include('da da-mumuki') }
      it { expect(breadcrumb).to include('test') }
      it { expect(breadcrumb).to include('my exercise') }
      it { expect(breadcrumb).to include('my guide') }
      it { expect(breadcrumb).to be_html_safe }

      it { expect(breadcrumb).to include home_breadcrumb_with_link }
      it { expect(breadcrumb).to include organization_breadcrumb_with_link }
      it { expect(breadcrumb).to include "<a href=\"/complements/#{complement.id}-my-guide\">my guide</a>" }
      it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>1. my exercise</li>" }
    end

    context 'exercise in chapter' do
      let!(:chapter) { create(:chapter, name: 'my chapter', lessons: [lesson]) }
      let(:lesson) { create(:lesson, name: 'my lesson', exercises: [exercise]) }
      let(:exercise) { create(:exercise, name: 'my exercise') }

      before { reindex_current_organization! }

      it { expect(breadcrumb).to include('da da-mumuki') }
      it { expect(breadcrumb).to include('test') }
      it { expect(breadcrumb).to include('my exercise') }
      it { expect(breadcrumb).to include('my lesson') }
      it { expect(breadcrumb).to include('my chapter') }
      it { expect(breadcrumb).to be_html_safe }

      it { expect(breadcrumb).to include home_breadcrumb_with_link }
      it { expect(breadcrumb).to include organization_breadcrumb_with_link }
      it { expect(breadcrumb).to include "<a href=\"/chapters/#{chapter.id}-my-chapter\">my chapter</a>" }
      it { expect(breadcrumb).to include "<a href=\"/lessons/#{lesson.id}-my-chapter-my-lesson\">1. my lesson</a>" }
      it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>1. my exercise</li>" }
    end
  end

  context 'book' do
    describe 'in organization with text breadcrumb' do
      let(:breadcrumb) { home_and_organization_breadcrumbs }

      it { expect(breadcrumb).to include('da da-mumuki') }
      it { expect(breadcrumb).to include('test') }

      it { expect(breadcrumb).to include home_breadcrumb_with_link }
      it { expect(breadcrumb).to_not include organization_breadcrumb_with_link }
    end

    describe 'in organization with image breadcrumb' do
      let(:breadcrumb) { home_and_organization_breadcrumbs }

      let(:organization) { create(:another_test_organization) }
      before { organization.switch! }

      before { organization.profile = Mumuki::Domain::Organization::Profile.new({breadcrumb_image_url: "organization.jpg"}) }

      it { expect(breadcrumb).to include('da da-mumuki') }
      it { expect(breadcrumb).to_not include('test') }

      it { expect(breadcrumb).to include home_breadcrumb_with_link }
      it { expect(breadcrumb).to_not include organization_breadcrumb_with_link }
      it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item '><img class=\"da mu-breadcrumb-img\" src=\"/images/organization.jpg\"" }
    end
  end
end
