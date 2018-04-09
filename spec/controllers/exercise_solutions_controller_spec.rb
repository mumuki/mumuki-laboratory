require 'spec_helper'

describe ExerciseSolutionsController, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:problem) { create(:problem) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, exercises: [problem])
    ]) }

  before { reindex_current_organization! }
  before { set_current_user! user }

  context 'when simple content is sent' do
    before { post :create, params: { exercise_id: problem.id, solution: { content: 'asd' } } }

    it { expect(response.status).to eq 200 }
    it { expect(Assignment.last.solution).to eq('asd')}
  end

  context 'when multifile content is sent' do
    before { post :create, params: { exercise_id: problem.id, solution: { content: { a_file: 'a content' } } } }

    it { expect(response.status).to eq 200 }
    it { expect(Assignment.last.solution).to eq("/*<a_file#*/a content/*#a_file>*/\n/*<content#*//*...a_file...*//*#content>*/") }
    it { expect(problem.files_for(user)).to eq [struct(name: 'a_file', content: 'a content')] }
  end
end
