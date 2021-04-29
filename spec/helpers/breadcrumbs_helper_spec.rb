require 'spec_helper'

describe BreadcrumbsHelper, organization_workspace: :test do

  helper BreadcrumbsHelper
  helper OrganizationBreadcrumbsHelper
  helper LinksHelper
  helper ERB::Util

  let(:home_breadcrumb_with_link) { "<li class='mu-breadcrumb-list-item brand'><a href=\"#{root_path}\">" }
  let(:organization_breadcrumb_with_link) { "<li class='mu-breadcrumb-list-item '><a href=\"#{root_path}\">" }
  let(:organization_breadcrumb_without_link) { "<li class='mu-breadcrumb-list-item last'><a href=\"#{root_path}\">" }

  context 'user' do
    let(:user) { create(:user, first_name: "Alfonsina", last_name: "Storni") }
    let(:breadcrumb) { breadcrumbs(user) }

    it { expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>Alfonsina Storni</li>" }
  end

  context 'exercise' do
    let(:breadcrumb) { breadcrumbs(exercise) }

    context 'in complement' do
      let!(:complement) { create(:complement, name: 'my guide', exercises: [
          create(:exercise, name: 'my exercise')
      ]) }
      let(:exercise) { complement.exercises.first }

      before { reindex_current_organization! }

      it 'breadcrumb goes mumuki / test organization / guide / exercise' do
        expect(breadcrumb).to include('da da-mumuki')
        expect(breadcrumb).to include('test')
        expect(breadcrumb).to include('my guide')
        expect(breadcrumb).to include('my exercise')
        expect(breadcrumb).to be_html_safe
      end

      it 'mumuki, organization and guide have links but exercise does not' do
        expect(breadcrumb).to include home_breadcrumb_with_link
        expect(breadcrumb).to include organization_breadcrumb_with_link
        expect(breadcrumb).to include "<a href=\"/complements/#{complement.id}-my-guide\">my guide</a>"
        expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>1. my exercise</li>"
      end
    end

    context 'in chapter' do
      let!(:chapter) { create(:chapter, name: 'my chapter', lessons: [lesson], number: 1) }
      let(:lesson) { create(:lesson, name: 'my lesson', exercises: [exercise]) }
      let(:exercise) { create(:exercise, name: 'my exercise') }

      before { reindex_current_organization! }

      it 'breadcrumb goes mumuki / test organization / chapter / lesson / exercise' do
        expect(breadcrumb).to include('da da-mumuki')
        expect(breadcrumb).to include('test')
        expect(breadcrumb).to include('my chapter')
        expect(breadcrumb).to include('my lesson')
        expect(breadcrumb).to include('my exercise')
        expect(breadcrumb).to be_html_safe
      end

      it 'mumuki, organization, chapter and lesson have links but exercise does not' do
        expect(breadcrumb).to include home_breadcrumb_with_link
        expect(breadcrumb).to include organization_breadcrumb_with_link
        expect(breadcrumb).to include "<a href=\"/chapters/#{chapter.id}-my-chapter\">1. my chapter</a>"
        expect(breadcrumb).to include "<a href=\"/lessons/#{lesson.id}-my-chapter-my-lesson\">1. my lesson</a>"
        expect(breadcrumb).to include "<li class='mu-breadcrumb-list-item last'>1. my exercise</li>"
      end
    end
  end

  context 'discussion' do
    let!(:chapter) { create(:chapter, name: 'my chapter', lessons: [lesson]) }
    let(:lesson) { create(:lesson, name: 'my lesson', exercises: [exercise]) }
    let(:exercise) { create(:exercise, name: 'my exercise') }

    let(:discussion) { create(:discussion, item: debatable) }
    let(:breadcrumb) { breadcrumbs_for_discussion(discussion, debatable) }

    before { reindex_current_organization! }

    context 'in exercise' do
      let(:debatable) { exercise }

      it 'breadcrumb goes mumuki / test organization / chapter / lesson / exercise / discussions / discussion' do
        expect(breadcrumb).to include('da da-mumuki')
        expect(breadcrumb).to include('test')
        expect(breadcrumb).to include('my chapter')
        expect(breadcrumb).to include('my lesson')
        expect(breadcrumb).to include('my exercise')
        expect(breadcrumb).to include('discussions')
        expect(breadcrumb).to include(discussion.item.navigable_name)
        expect(breadcrumb).to be_html_safe
      end
    end
  end

  context 'book' do
    let(:breadcrumb) { header_breadcrumbs(link_for_organization: false) }

    describe 'in organization with text breadcrumb' do
      it 'breadcrumb goes mumuki / test organization' do
        expect(breadcrumb).to include('da da-mumuki')
        expect(breadcrumb).to include('test')
      end

      it 'mumuki has link but organization does not' do
        expect(breadcrumb).to include home_breadcrumb_with_link
        expect(breadcrumb).to include organization_breadcrumb_without_link
      end
    end

    describe 'in organization with image breadcrumb' do
      before { Organization.current.profile = Mumuki::Domain::Organization::Profile.new({breadcrumb_image_url: "organization.jpg"}) }

      it 'breadcrumb goes mumuki / organization logo' do
        expect(breadcrumb).to include('da da-mumuki')
        expect(breadcrumb).to_not include('test')
      end

      it 'mumuki has link but organization logo does not' do
        expect(breadcrumb).to include home_breadcrumb_with_link
        expect(breadcrumb).to include organization_breadcrumb_without_link
      end
    end
  end
end
