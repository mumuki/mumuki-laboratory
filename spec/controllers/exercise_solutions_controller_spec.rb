require 'spec_helper'

describe ExerciseSolutionsController, organization_workspace: :test do
  let(:user) { create(:user) }
  let(:problem) { create(:problem) }
  let(:kids_problem) { create(:problem, layout: :input_kids) }
  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, exercises: [problem, kids_problem])
    ]) }

  before { reindex_current_organization! }
  before { set_current_user! user }

  def post_problem(problem)
    post :create, params: { exercise_id: problem.id, solution: { content: 'asd' } }
  end


  describe 'when simple content is sent' do
    context 'for a non-kids exercise' do
      before { post_problem(problem) }
      let(:assignment) { Assignment.last }

      context 'without client-side interpolations' do
        it { expect(response.status).to eq 200 }
        it { expect(assignment.solution).to eq('asd')}

        it { expect(response.body).to json_eq({ status: :failed, guide_finished_by_solution: false },
                                              except: [:class_for_progress_list_item, :html, :remaining_attempts_html]) }


        it 'does not include kids specific renders' do
          body = JSON.parse(response.body)

          expect(body.key?('button_html')).to be false
          expect(body.key?('title_html')).to be false
          expect(body.key?('expectations_html')).to be false
          expect(body.key?('test_results')).to be false
        end
      end

      context 'with client-side interpolations' do
        let(:problem) { create(:problem, extra: interpolation) }
        let(:interpolation) { %q{function longitud(unString) /*<elipsis-for-student@*/ {
          return unString.length;
        } /*@elipsis-for-student>*/} }

        it { expect(assignment.extra.strip).to eq interpolation.strip }
      end
    end

    context 'for a kids exercise' do
      before { post_problem(kids_problem) }

      it { expect(response.body).to json_eq({ status: :failed, guide_finished_by_solution: false },
                                            except: [:class_for_progress_list_item, :html, :remaining_attempts_html,
                                                     :title_html, :button_html, :expectations_html, :test_results]) }

      it 'includes kids specific renders' do
        body = JSON.parse(response.body)

        expect(body.key?('button_html')).to be true
        expect(body.key?('title_html')).to be true
        expect(body.key?('expectations_html')).to be true
        expect(body.key?('test_results')).to be true
      end
    end
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
