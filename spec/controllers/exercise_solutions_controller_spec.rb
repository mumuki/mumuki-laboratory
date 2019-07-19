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
    it { expect(response.body).to json_eq(
                                    {status: :failed, guide_finished_by_solution: false},
                                    except: [:class_for_progress_list_item,
                                             :html, :title_html, :button_html,
                                             :expectations_html, :remaining_attempts_html,
                                             :test_results]) }
    it { expect(Assignment.last.solution).to eq('asd')}
  end

  context 'when multifile content is sent' do
    before { create(:language, extension: 'js', highlight_mode: 'javascript') }
    before { post :create, params: { exercise_id: problem.id, solution: { content: {
      'a_file.css' => 'a css content',
      'a_file.js' => 'a js content'
    } } } }
    let(:files) { Assignment.last.files }

    it { expect(response.status).to eq 200 }
    it { expect(Assignment.last.solution).to eq("/*<a_file.css#*/a css content/*#a_file.css>*/\n/*<a_file.js#*/a js content/*#a_file.js>*/") }
    it { expect(files.count).to eq 2 }
    it { expect(files[0]).to have_attributes(name: 'a_file.css', content: 'a css content') }
    it { expect(files[0].highlight_mode).to eq 'css' }
    it { expect(files[1]).to have_attributes(name: 'a_file.js', content: 'a js content') }
    it { expect(files[1].highlight_mode).to eq 'javascript' }
  end
end
