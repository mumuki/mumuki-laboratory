require 'spec_helper'

describe Exercise, organization_workspace: :test do
  let(:exercise) { create(:exercise) }
  let(:user) { create(:user, first_name: 'Orlo') }

  describe '#choice_values' do
    context 'when choices are in 5.0 format' do
      let(:choice_values) { %w(1492 1453 1773)  }
      let(:exercise) { build(:exercise, description: 'when did byzantine empire fall?', choice_values: choice_values) }

      it { expect(exercise.choices).to be_blank }
      it { expect(exercise[:choice_values]).to eq choice_values }
      it { expect(exercise.choice_values).to eq choice_values }
      it { expect(exercise.choice_index_for '1492').to eq 0 }
      it { expect(exercise.choice_index_for '1773').to eq 2 }
    end

    context 'when choices are in 6.0 format' do
      let(:choices) { [{value: '1492', checked: false}, {value: '1453', checked: true}, {value: '1773', checked: false}] }
      let(:exercise) { build(:exercise, description: 'when did byzantine empire fall?', choices: choices) }

      it { expect(exercise.choices).to eq choices }
      it { expect(exercise[:choice_values]).to be_blank }
      it { expect(exercise.choice_values).to eq %w(1492 1453 1773) }
      it { expect(exercise.choice_index_for '1492').to eq 0 }
      it { expect(exercise.choice_index_for '1773').to eq 2 }
    end
  end

  describe '#slug' do
    let(:guide) { create(:guide, slug: 'foo/bar') }
    let(:exercise) { create(:exercise, guide: guide, bibliotheca_id: 4) }
    it { expect(exercise.slug).to eq 'foo/bar/4' }
  end

  describe '#new_solution' do
    context 'when there is default content' do
      let(:exercise) { create(:exercise, default_content: 'foo') }

      it { expect(exercise.new_solution.content).to eq 'foo' }
    end

    context 'when there is no default content' do
      let(:exercise) { create(:exercise) }

      it { expect(exercise.new_solution.content).to be_blank }
    end
  end

  describe '#next_for' do
    context 'when exercise has no guide' do
      it { expect(exercise.next_for(user)).to be nil }
    end
    context 'when exercise belong to a guide with a single exercise' do
      let(:exercise_with_guide) { create(:exercise, guide: guide) }
      let(:guide) { create(:guide) }

      it { expect(exercise_with_guide.next_for(user)).to be nil }
    end
    context 'when exercise belongs to a guide with two exercises' do
      let!(:exercise_with_guide) { create(:exercise, guide: guide, number: 2) }
      let!(:alternative_exercise) { create(:exercise, guide: guide, number: 3) }
      let!(:guide) { create(:guide) }

      it { expect(exercise_with_guide.next_for(user)).to eq alternative_exercise }
    end

    context 'when exercise belongs to a guide with two exercises and alternative exercise has being solved' do
      let(:exercise_with_guide) { create(:exercise, guide: guide) }
      let!(:alternative_exercise) { create(:exercise, guide: guide) }
      let(:guide) { create(:guide) }

      before { alternative_exercise.submit_solution!(user, content: 'foo').passed! }

      it { expect(exercise_with_guide.next_for(user)).to be nil }
    end

    context 'when exercise belongs to a guide with two exercises and alternative exercise has being submitted but not solved' do
      let!(:exercise_with_guide) { create(:exercise, guide: guide, number: 2) }
      let!(:alternative_exercise) { create(:exercise, guide: guide, number: 3) }
      let(:guide) { create(:guide) }

      before { alternative_exercise.submit_solution!(user, content: 'foo') }

      it { expect(guide.pending_exercises(user)).to_not eq [] }
      it { expect(guide.next_exercise(user)).to_not be nil }
      it { expect(guide.pending_exercises(user)).to include(alternative_exercise) }
      it { expect(exercise_with_guide.next_for(user)).to eq alternative_exercise }
      it { expect(guide.exercises).to_not eq [] }
      it { expect(exercise_with_guide.guide).to eq guide }
      it { expect(guide.pending_exercises(user)).to include(exercise_with_guide) }
    end
  end

  describe '#extra' do
    context 'when exercise has no extra code' do
      it { expect(exercise.extra).to eq '' }
    end

    context 'when exercise has extra code and has no guide' do
      let!(:exercise_with_extra) { create(:exercise, extra: 'exercise extra code') }

      it { expect(exercise_with_extra.extra).to eq "exercise extra code\n" }
    end

    context 'when exercise has extra code and ends with new line and has no guide' do
      let!(:exercise_with_extra) { create(:exercise, extra: "exercise extra code\n") }

      it { expect(exercise_with_extra.extra).to eq "exercise extra code\n" }
    end

    context 'when exercise has extra code and belongs to a guide with no extra code' do
      let!(:exercise_with_extra) { create(:exercise, guide: guide, extra: 'exercise extra code') }
      let!(:guide) { create(:guide) }

      it { expect(exercise_with_extra.extra).to eq "exercise extra code\n" }
    end

    context 'when exercise has extra code with trailing whitespaces
             and belongs to a guide with no extra code' do
      let!(:exercise_with_extra) { create(:exercise, guide: guide, extra: "\nexercise extra code \n") }
      let!(:guide) { create(:guide) }

      it { expect(exercise_with_extra.extra).to eq "exercise extra code\n" }
    end

    context 'when exercise has extra code and belongs to a guide with extra code' do
      let!(:exercise_with_extra) { create(:exercise, guide: guide, extra: 'exercise extra code') }
      let!(:guide) { create(:guide, extra: 'guide extra code') }

      it { expect(exercise_with_extra.extra).to eq "guide extra code\nexercise extra code\n" }
      it { expect(exercise_with_extra[:extra]).to eq 'exercise extra code' }
    end
  end

  describe '#extra_preview' do
    let(:haskell) { create(:haskell) }
    let(:guide) { create(:guide,
                         extra: 'f x = 1',
                         language: haskell,
                         exercises: [create(:exercise,
                                            extra: 'g y = y + 3',
                                            language: haskell)]) }
    let(:exercise) { guide.exercises.first }

    it { expect(exercise.assignment_for(user).extra_preview).to eq "```haskell\nf x = 1\ng y = y + 3\n```" }
  end

  describe '#submit_solution!' do
    context 'when user did a submission' do
      before { exercise.submit_solution!(user) }
      it { expect(exercise.find_assignment_for(user)).to be_present }
    end
    context 'when user did no submission' do
      it { expect(exercise.find_assignment_for(user)).to be_blank }
    end
  end

  describe '#destroy' do
    context 'when there are no submissions' do
      it { exercise.destroy! }
    end

    context 'when there are submissions' do
      let!(:assignment) { create(:assignment, exercise: exercise) }
      before { exercise.destroy! }
      it { expect { Assignment.find(assignment.id) }.to raise_error(ActiveRecord::RecordNotFound) }
    end

  end

  describe '#previous_solution_for' do
    context 'when user has a single submission for the exercise' do
      let!(:assignment) { exercise.submit_solution!(user, content: 'foo') }

      it { expect(assignment.current_content).to eq assignment.solution }
    end

    context 'when user has no submissions for the exercise' do
      it { expect(exercise.assignment_for(user).current_content).to eq '' }
    end

    context 'when using an interpolation' do
      let!(:chapter) {
        create(:chapter, lessons: [
          create(:lesson, exercises: [
            first_exercise,
            second_exercise,
            previous_exercise,
            exercise
          ])]) }

      let(:first_exercise) { create(:exercise) }
      let(:second_exercise) { create(:exercise) }
      let(:previous_exercise) { create(:exercise) }

      before { reindex_current_organization! }

      context 'when interpolation is in default_content' do
        let(:assignment) { exercise.assignment_for(user) }

        describe 'right previous content' do
          let(:exercise) { create(:exercise, default_content: interpolation) }

          context 'using previousContent' do
            let(:interpolation) { '/*...previousContent...*/' }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end

            context 'does not have previous submission' do
              it { expect(assignment.current_content).to eq '' }
            end
          end
          context 'using previousSolution' do
            let(:interpolation) { '/*...previousSolution...*/' }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end

            context 'does not have previous submission' do
              it { expect(assignment.current_content).to eq '' }
            end
          end
        end

        describe 'indexed previous content' do
          context '-2 index' do
            let(:exercise) { create(:exercise, default_content: '/*...solution[-2]...*/') }

            context 'has previous submission' do
              before { second_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end
          end
          context '-1 index' do
            let(:exercise) { create(:exercise, default_content: '/*...solution[-1]...*/') }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end

            context 'does not have previous submission' do
              it { expect(assignment.current_content).to eq '' }
            end
          end
          context '1 index' do
            let(:exercise) { create(:exercise, default_content: '/*...solution[1]...*/') }

            context 'has previous submission' do
              before { first_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end
          end
          context '2 index' do
            let(:exercise) { create(:exercise, default_content: '/*...solution[2]...*/') }

            context 'has previous submission' do
              before { second_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end
          end
          context '3 index' do
            let(:exercise) { create(:exercise, default_content: '/*...solution[3]...*/') }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.current_content).to eq 'foobar' }
            end
          end
        end
      end
      context 'when interpolation is in test' do
        let(:assignment) { exercise.assignment_for(user) }

        context 'using user_first_name'  do
          let(:exercise) { create(:exercise, test: "<div>Hola #{interpolation}</div>") }
          let(:interpolation) { '/*...user_first_name...*/' }

          it { expect(assignment.test).to eq "<div>Hola Orlo</div>" }
        end

        context 'and test is nil'  do
          let(:exercise) { create(:exercise, test: nil, expectations: [{binding: "program", inspection: 'Uses:foo'}]) }

          it { expect(assignment.test).to eq nil }
        end
      end
      context 'when interpolation is in extra' do
        let(:assignment) { exercise.assignment_for(user) }

        describe 'right previous content' do
          let(:exercise) { create(:exercise, extra: interpolation) }

          context 'using previousContent' do
            let(:interpolation) { '/*...previousContent...*/' }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end

            context 'does not have previous submission' do
              it { expect(assignment.extra).to eq "\n" }
            end
          end
          context 'using previousSolution' do
            let(:interpolation) { '/*...previousSolution...*/' }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end

            context 'does not have previous submission' do
              it { expect(assignment.extra).to eq "\n" }
            end
          end
        end

        describe 'indexed previous content' do
          context '-2 index' do
            let(:exercise) { create(:exercise, extra: '/*...solution[-2]...*/') }

            context 'has previous submission' do
              before { second_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end
          end
          context '-1 index' do
            let(:exercise) { create(:exercise, extra: '/*...solution[-1]...*/') }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end

            context 'does not have previous submission' do
              it { expect(assignment.extra).to eq "\n" }
            end
          end
          context '1 index' do
            let(:exercise) { create(:exercise, extra: '/*...solution[1]...*/') }

            context 'has previous submission' do
              before { first_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end
          end
          context '2 index' do
            let(:exercise) { create(:exercise, extra: '/*...solution[2]...*/') }

            context 'has previous submission' do
              before { second_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end
          end
          context '3 index' do
            let(:exercise) { create(:exercise, extra: '/*...solution[3]...*/') }

            context 'has previous submission' do
              before { previous_exercise.submit_solution!(user, content: 'foobar') }
              it { expect(assignment.extra).to eq "foobar\n" }
            end
          end
        end
      end
    end

    context 'when user has multiple submission for the exercise' do
      before { exercise.submit_solution!(user, content: 'foo') }
      let!(:assignment) { exercise.submit_solution!(user, content: 'bar') }

      it { expect(assignment.current_content).to eq assignment.solution }
    end

    context 'when user has no solution and exercise has default content' do
      let(:exercise) { create(:exercise, default_content: '#write here...') }
      let(:assignment) { exercise.assignment_for user }

      it { expect(assignment.current_content).to eq '#write here...' }
    end
  end

  describe '#guide_done_for?' do

    context 'when it does not belong to a guide' do
      it { expect(exercise.guide_done_for?(user)).to be false }
    end

    context 'when it belongs to a guide unfinished' do
      let!(:guide) { create(:guide) }
      let!(:exercise_unfinished) { create(:exercise, guide: guide) }
      let!(:exercise_finished) { create(:exercise, guide: guide) }

      before do
        exercise_finished.submit_solution!(user, content: 'foo').passed!
      end

      it { expect(exercise_finished.guide_done_for?(user)).to be false }
    end

    context 'when it belongs to a guide unfinished' do
      let!(:guide) { create(:guide) }
      let!(:exercise_finished) { create(:exercise, guide: guide) }
      let!(:exercise_finished2) { create(:exercise, guide: guide) }

      before do
        exercise_finished.submit_solution!(user, content: 'foo').passed!
        exercise_finished2.submit_solution!(user, content: 'foo').passed!
      end

      it { expect(exercise_finished.guide_done_for?(user)).to be true }
    end
  end

  describe '#language' do
    let(:guide) { create(:guide) }
    let(:exercise_with_guide) { create(:exercise, guide: guide, language: guide.language) }
    let(:other_language) { create(:language) }

    context 'when has no guide' do
      it { expect(exercise.valid?).to be true }
    end

    context 'when has guide and is consistent' do
      it { expect(exercise_with_guide.valid?).to be true }
    end
  end

  describe '#friendly_name' do
    it { expect(Exercise.find(exercise.friendly_name)).to eq exercise }
    it { expect(Problem.find(exercise.friendly_name)).to eq exercise }
  end

  describe 'messages_path_for' do
    let(:haskell) { create(:haskell) }
    let(:problem) { create(:problem, bibliotheca_id: 32, guide: guide, language: haskell) }
    let(:guide) { create(:guide, slug: 'mumuki/myguide') }

    context 'user with email uid' do
      let(:student) { create(:user, uid: 'foo@bar.com') }

      it { expect(problem.messages_path_for(student))
             .to eq 'api/guides/mumuki/myguide/32/student/foo@bar.com/messages?language=haskell' }
      it { expect(problem.messages_url_for(student))
             .to eq 'http://test.classroom-api.localmumuki.io/api/guides/mumuki/myguide/32/student/foo@bar.com/messages?language=haskell' }
    end

    context 'user with twitter uid' do
      let(:student) { create(:user, uid: 'twitter|12134342') }

      it { expect(problem.messages_url_for(student))
             .to eq 'http://test.classroom-api.localmumuki.io/api/guides/mumuki/myguide/32/student/twitter%7C12134342/messages?language=haskell' }
    end
  end

  describe '#splitted_description' do
    let(:exercise) { create(:exercise, description: "**Foo**\n\n> _Bar_") }
    it { expect(exercise.description_context).to eq "<p><strong>Foo</strong></p>\n" }
    it { expect(exercise.description_task).to eq "<p><em>Bar</em></p>\n" }
  end

  describe '#validate!' do
    context 'non-empty, valid randomizations' do
      let(:exercise) { build(:exercise,
                            randomizations: {
                              some_word: { type: :one_of, value: %w('some' 'word') },
                              some_number: { type: :range, value: [1, 10] } }) }
      it { expect { exercise.validate! }.not_to raise_error }
    end

    context 'empty inspections' do
      let(:exercise) { build(:exercise, expectations: [{ "binding" => "program", "inspection" => "" }]) }
      it { expect { exercise.validate! }.to raise_error(/expectations format is invalid/i) }
    end

    context 'invalid assistance_rules' do
      let(:exercise) { build(:exercise, assistance_rules: [{ when: 'content_empty', then: ['asd'] }]) }
      it { expect { exercise.validate! }.to raise_error(/assistance rules format is invalid/i) }
    end

    context 'invalid randomizations' do
      let(:exercise) { build(:exercise, randomizations: { type: :range, value: [1] }) }
      it { expect { exercise.validate! }.to raise_error(/randomizations format is invalid/i) }
    end
  end

  describe '#files_for' do
    before { create(:language, extension: 'js', highlight_mode: 'javascript') }
    let(:current_content) { "/*<index.html#*/a html content/*#index.html>*/\n/*<a_file.js#*/a js content/*#a_file.js>*/" }
    let(:assignment) { build(:assignment, exercise: exercise, solution: current_content) }
    let(:files) { exercise.files_for(current_content) }

    it { expect(files.count).to eq 2 }
    it { expect(files[0]).to have_attributes(name: 'index.html', content: 'a html content') }
    it { expect(files[0].highlight_mode).to eq 'html' }
    it { expect(files[1]).to have_attributes(name: 'a_file.js', content: 'a js content') }
    it { expect(files[1].highlight_mode).to eq 'javascript' }
    it { expect(files.to_json).to eq assignment.files.to_json }
  end
end
