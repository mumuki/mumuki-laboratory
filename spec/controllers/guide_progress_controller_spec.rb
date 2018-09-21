require 'spec_helper'

describe GuideProgressController, organization_workspace: :test do
  let(:user) { create(:user) }

  let(:exam_problem) { build(:problem) }
  let(:test_organization) { Organization.find_by_name('test') }
  let(:exam) { create(:exam, organization: test_organization, guide: guide) }
  let(:guide) { create(:guide, exercises: [exam_problem])}

  before { exam.index_usage! test_organization }

  before { reindex_current_organization! }

  describe 'delete' do
    before { set_current_user! user }
    before { delete :destroy, params: { guide_id: guide.id } }

    it { expect(response.status).to eq 403 }
  end
end
