require 'spec_helper'

describe GuideProgressController, organization_workspace: :test do
  let(:user) { create(:user) }

  let(:exam_problem) { build(:problem) }
  let(:test_organization) { Organization.find_by_name('test') }
  let(:exam) { create(:exam, organization: test_organization, guide: exam_guide) }
  let(:lesson) { create(:lesson, guide: lesson_guide) }

  describe 'delete' do
    before { set_current_user! user }

    describe 'an exam guide progress' do
      let(:exam_guide) { create(:guide, exercises: [exam_problem])}
      before { exam.index_usage! test_organization }
      before { reindex_current_organization! }
      before { delete :destroy, params: { guide_id: exam_guide.id } }

      it { expect(response.status).to eq 403 }
    end

    describe 'a lesson guide progress' do
      let(:book) { create(:book,
                          slug: 'mumuki/book',
                          chapters: [
                            create(:chapter,
                                   slug: 'mumuki/topic1',
                                   lessons: [lesson])]) }

      let(:lesson_guide) { create(:guide, exercises: [exam_problem])}
      before { test_organization.update! book: book }
      before { lesson.index_usage! test_organization }
      before { reindex_current_organization! }
      before { delete :destroy, params: { guide_id: lesson_guide.id } }

      it { expect(response.status).to eq 302 }
    end
  end
end
