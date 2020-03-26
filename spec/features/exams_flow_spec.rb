require 'spec_helper'

feature 'Exams Flow', organization_workspace: :test do
  let(:exam) { create(:exam, classroom_id: '12345') }
  let(:other_exam) { create(:exam, organization: other_organization) }
  let!(:exam_not_in_path) { create :exam }

  let(:other_organization) { create(:organization, name: 'baz') }

  let(:test_organization) { Organization.locate! 'test' }
  let(:exam_with_no_submission_limits) { create(:exam, organization: test_organization, guide: guide) }

  let(:capped_exam) { create(:exam, organization: test_organization, guide: problems_guide, max_choice_submissions: 2, max_problem_submissions: 5) }

  let(:guide) { create(:guide, exercises: [exercise])}
  let(:exercise) { create(:exercise, name: 'Exam Exercise') }

  let(:problems_guide) { create(:guide, exercises: [choice_problem, code_problem])}

  let(:choice_problem) { create(:problem, name: 'Exam Choice Problem', editor: :multiple_choice,
    choices: [{ value: "A", checked: true }, { value: "B", checked: false }]) }

  let(:code_problem) { create(:problem, name: 'Exam Code Problem') }

  before { exam_with_no_submission_limits.index_usage! test_organization }

  before { reindex_current_organization! }

  context 'inexistent exam' do
    scenario 'visit exam by id, not in path' do
      visit "/exams/#{exam_not_in_path.id}"
      expect(page).to have_text('You have no permissions for this content. Maybe you logged in with another account.')
    end

    scenario 'visit exam by id, unknown exam' do
      visit '/exams/900000'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end

  scenario 'visit exam not in path, by id, anonymous' do
   visit "/exams/#{other_exam.id}"
    expect(page).to have_text('You may have mistyped the address or the page may have moved')
  end

  scenario 'visit exam in path, by id, anonymous' do
    visit "/exams/#{exam.id}"

    expect(page).to have_text('You have no permissions for this content.')
  end

  scenario 'visit exam in path, by classroom id, anonymous' do
    visit "/exams/#{exam.classroom_id}"

    expect(page).to have_text('You have no permissions for this content.')
  end

  context 'visit authorized exam for user' do
    let(:user) { create(:user) }
    let(:current_exam) { exam }

    before do
      current_exam.authorize! user
      set_current_user! user
    end

    scenario 'in path, when there is no more time' do
      expect_any_instance_of(Exam).to receive(:enabled_for?).and_return(false)
      visit "/exams/#{current_exam.classroom_id}"

      expect(page).to have_text('This content is no longer available.')
    end

    feature 'with no submission limits' do
      let(:current_exam) { exam_with_no_submission_limits }

      scenario 'in a particular exercise' do
        visit "/exercises/#{exercise.id}"

        expect(page).to have_text('Exam Exercise')
      end
    end

    feature 'with submission limits' do
      let(:current_exam) { capped_exam }

      feature 'when user has no remaining attempts' do
        feature 'for code problem' do
          before { 5.times { code_problem.submit_solution!(user, content: 'foo')  } }

          scenario do
            visit "/exercises/#{code_problem.id}"

            expect(page).to have_text('Exam Code Problem')
            expect(page).to have_text('out of attempts')
          end
        end

        feature 'for choice problem' do
          before { 2.times { choice_problem.submit_solution!(user, content: 'foo')  } }

          scenario do
            visit "/exercises/#{choice_problem.id}"

            expect(page).to have_text('Exam Choice Problem')
            expect(page).to have_text('out of attempts')
          end
        end
      end

      feature 'when user has remaining attempts' do
        feature 'for code problem' do
          before { 2.times { code_problem.submit_solution!(user, content: 'foo') } }

          scenario do
            visit "/exercises/#{code_problem.id}"

            expect(page).to have_text('Exam Code Problem')
            expect(page).to have_text('3 attempts remaining')
          end
        end

        feature 'for choice problem' do
          before { 1.times { choice_problem.submit_solution!(user, content: 'foo') } }

          scenario do
            visit "/exercises/#{choice_problem.id}"

            expect(page).to have_text('Exam Choice Problem')
            expect(page).to have_text('1 attempt remaining')
          end
        end
      end
    end
  end
end
