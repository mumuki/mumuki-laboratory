require 'spec_helper'

feature 'Create guide flow' do
  let(:user) { User.first }

  before do
    allow_any_instance_of(WithGitGuide).to receive(:repo_exists?).and_return(true)
  end

  before do
    visit '/'

    click_on 'Sign in with Github'

    visit "es/users/#{user.id}/guides"

    click_on 'New Guide'

    expect(page).to have_text('Step 1')

    fill_in 'name', with: 'fooGuide'
    fill_in 'github_repository', with: 'flbulgarelli/mumuki-test-guide'

    click_on 'Create Guide'

    expect(page).to have_text('Step 2')

    expect(page).to have_text('Import guide')
  end

  scenario 'Create guide manually flow' do
    click_on 'Edit Guide Manually'

    fill_in 'description', with: 'a description'

    click_on 'Update Guide'
  end

  scenario 'Create guide and import flow' do
    expect_any_instance_of(WithGitGuide).to receive(:clone_repo_into) {}

    click_on 'Import Guide'
  end

  scenario 'Create guide manually and the export flow' do
    expect_any_instance_of(WithGitGuide).to receive(:clone_repo_into) {}
    expect_any_instance_of(WithGitGuide).to receive(:create_repo!) {}
    click_on 'Edit Guide Manually'

    fill_in 'description', with: 'a description'

    click_on 'Update Guide'

    click_on 'Export Guide'
  end

end
