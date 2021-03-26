require 'spec_helper'

feature 'Exercise Flow', organization_workspace: :test do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }
  let(:gobstones) { create(:gobstones) }

  let(:problem_1) { build(:problem, name: 'Succ1', description: 'Description of Succ1', layout: :input_right, hint: 'lala') }
  let(:problem_2) { build(:problem, name: 'Succ2', description: 'Description of Succ2', layout: :input_right, editor: :hidden, language: gobstones) }
  let(:problem_3) { build(:problem, name: 'Succ3', description: 'Description of Succ3', layout: :input_right, editor: :upload, hint: 'lele') }
  let(:with_settings_and_extra) do
    build(:problem, name: 'Succ4', description: 'Description of Succ4', layout: :input_bottom, settings: {foo: 1}, extra: 'x = 2')
  end
  let(:problem_5) { build(:problem, name: 'Succ5', description: 'Description of Succ5', layout: :input_right, editor: :upload, hint: 'lele', language: gobstones) }
  let(:problem_6) { build(:problem, name: 'Succ6', description: 'Description of Succ6', layout: :input_right, editor: :hidden, language: haskell) }
  let(:problem_7) { build(:problem, name: 'Succ7', description: 'Description of Succ7', editor: :single_choice, choices: [{value: 'some choice', checked: true}]) }
  let(:playground_1) { build(:playground, name: 'Succ5', description: 'Description of Succ4', layout: :input_bottom) }
  let(:playground_2) { build(:playground, name: 'Succ6', description: 'Description of Succ4', layout: :input_bottom, extra: 'x = 4') }
  let!(:reading) { build(:reading, name: 'Reading about Succ', description: 'Lets understand succ history') }
  let!(:exercise_not_in_path) { create :exercise }
  let(:kids_problem) { build(:problem, name: 'Kids prob', description: 'Description of kids prob', layout: :input_primary, hint: 'lele', language: gobstones) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [
        problem_1, problem_2, problem_3, with_settings_and_extra, reading, problem_5, problem_6, problem_7, playground_1, playground_2, kids_problem
      ])
    ]) }

  before { reindex_current_organization! }

  context 'inexistent exercise' do
    scenario 'visit exercise transparently, not in path' do
      visit "/exercises/#{exercise_not_in_path.transparent_id}"
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit exercise transparently, unknown exercise' do
      visit '/exercises/an_exercise_transparent_id'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit exercise by id, not in path' do
      visit "/exercises/#{exercise_not_in_path.id}"
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit exercise by id, unknown exercise' do
      visit '/exercises/900000'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end

  context 'not logged user' do
    scenario 'visit exercise transparently' do
      visit "/exercises/#{problem_1.transparent_id}"

      expect(page).to have_text('Succ1')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit kids exercise transparently' do
      visit "/exercises/#{kids_problem.transparent_id}"

      expect(page).to have_text('Kids prob')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('Description of kids prob')
    end

    scenario 'visit exercise by id, upload layout' do
      visit "/exercises/#{problem_3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'should not see the edit exercise link' do
      visit "/exercises/#{problem_2.id}"
      expect(page).not_to have_xpath("//a[@title='Edit']")
    end
  end


  context 'logged user' do
    before { set_current_user! user }
    let(:writer) { create(:user, permissions: {student: 'private/*', writer: 'private/*'}) }

    scenario 'visit exercise transparently' do
      visit "/exercises/#{problem_1.transparent_id}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    describe 'embedded mode' do
      scenario 'visit exercise by id, standalone mode' do
        visit "/exercises/#{problem_1.id}"
        expect(page).to have_text('Functional Programming 1')
        expect(page).to have_text('My account')
      end
      scenario 'visit exercise by id, embedded mode in non embeddable organization' do
        visit "/exercises/#{problem_1.id}?embed=true"
        expect(page).to have_text('Functional Programming 1')
        expect(page).to have_text('My account')
      end
      scenario 'visit exercise by id, embedded mode in embeddable organization' do
        Organization.current.tap { |it| it.embeddable = true }.save!

        visit "/exercises/#{problem_1.id}?embed=true"
        expect(page).to_not have_text('Functional Programming 1')
        expect(page).to_not have_text('My account')
      end
    end


    scenario 'visit exercise by id, editor right layout' do
      visit "/exercises/#{problem_1.id}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to_not have_selector('.upload')

      expect(page).to have_selector('#mu-exercise-id', )
      expect(page).to have_selector('#mu-exercise-layout')

      expect(page.find("#mu-exercise-id")['value']).to eq(problem_1.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_right')
    end

    scenario 'visit exercise by id, hidden layout, no hint, not queriable language' do
      visit "/exercises/#{problem_2.id}"

      expect(page).to have_text('Succ2')
      expect(page).to have_text('Continue')
      expect(page).to_not have_text('Submit')

      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(problem_2.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_right')
    end

    scenario 'visit exercise by id, hidden layout, no hint, queriable language' do
      visit "/exercises/#{problem_6.id}"

      expect(page).to have_text('Succ6')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(problem_6.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_right')
    end


    scenario 'visit exercise by id, upload layout' do
      visit "/exercises/#{problem_3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(problem_3.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_right')
    end

    scenario 'visit exercise by id, upload layout, not queriable language', :invalid_selector_error do
      visit "/exercises/#{problem_5.id}"

      expect(page).to have_text('Succ5')
      expect(page).to_not have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_selector('.upload')
      expect(problem_5.language.extension).to eq('gbs')
      expect(page.find("//input[@id = 'mu-upload-input']")['accept']).to eq(".gbs")

      expect(page.find("#mu-exercise-id")['value']).to eq(problem_5.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_right')
    end

    scenario 'visit exercise by id, input_bottom layout, extra, setting, no hint' do
      visit "/exercises/#{with_settings_and_extra.id}"

      expect(page).to have_text('Succ4')
      expect(page).to have_text('x = 2')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(with_settings_and_extra.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_bottom')
      expect(page.find("#mu-exercise-settings")['value']).to eq('{"foo":1}')
    end

    scenario 'visit playground by id, no extra, no hint' do
      visit "/exercises/#{playground_1.id}"

      expect(page).to have_text('Succ5')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(playground_1.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_bottom')
    end

    scenario 'visit playground by id, with extra, no hint' do
      visit "/exercises/#{playground_2.id}"

      expect(page).to have_text('Succ6')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to have_text('x = 4')
      expect(page).to_not have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(playground_2.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_bottom')
    end

    scenario 'visit inner reading by id' do
      visit "/exercises/#{reading.id}"

      expect(page).to have_text('Reading about Succ')
      expect(page).to have_text('Lets understand succ history')

      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')

      expect(page.find("#mu-exercise-id")['value']).to eq(reading.id.to_s)
      expect(page.find("#mu-exercise-layout")['value']).to eq('input_bottom')
    end

    scenario 'visit solved choices exercise' do
      problem_7.submit_solution!(user, content: '').passed!
      visit "/exercises/#{problem_7.id}"

      expect(page).to have_text 'The answer is correct!'
    end

    scenario 'visit failed choices exercise' do
      problem_7.submit_solution!(user, content: '').failed!
      visit "/exercises/#{problem_7.id}"

      expect(page).to have_text 'The answer is wrong'
    end

    scenario 'with no permissions should not see the edit exercise link' do
      visit "/exercises/#{problem_2.id}"
      expect(page).not_to have_xpath("//a[@title='Edit']")
    end

    scenario 'writer should see the edit exercise link', :xpath_no_matches do
      set_current_user! writer

      visit "/exercises/#{problem_2.id}"
      expect(page).to have_xpath("//a[@title='Edit']")
    end
  end

  context 'incognito user' do
    before { Organization.current.update! incognito_mode_enabled: true }

    scenario 'visit exercise transparently' do
      visit "/exercises/#{problem_1.transparent_id}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')

      expect(page).to have_text('Sign in')
    end
  end
end
