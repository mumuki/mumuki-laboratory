require 'spec_helper'

feature 'Create guide flow' do
  let(:user) { User.first }

  before do
    expect_any_instance_of(WithGitAccess).to receive(:ensure_repo_exists!) {}
    expect_any_instance_of(WithGitAccess).to receive(:register_post_commit_hook!) {}

    allow_any_instance_of(WithGitAccess).to receive(:clone_repo_into) {}
  end

  before do
    visit '/'

    click_on 'Sign in with Github'

    visit "/users/#{user.id}/guides"

    click_on 'New Guide'

    fill_in 'guide_name', with: 'fooGuide'
    fill_in 'guide_github_repository', with: 'flbulgarelli/mumuki-test-guide'

    click_on 'Create Guide'

    expect(page).to have_text('Guide created successfully')

    expect(page).to have_text('Import/Export')
    expect(page).to have_text('Info')
    expect(page).to have_text('Basic')
  end

  scenario 'Create guide manually flow' do
    click_on 'Info'

    fill_in 'guide_description', with: 'a description'

    within '#info-panel' do
      click_on 'Update Guide'
    end

    expect(page).to have_text('Guide was successfully updated')

  end

  scenario 'Rename guide' do
    fill_in 'guide_name', with: 'anotherName'

    within '#basic-panel' do
      click_on 'Update Guide'
    end

    expect(page).to have_text('Guide was successfully updated')

  end

  scenario 'Create guide and import flow' do
    click_on 'Import/Export'

    click_on 'Import now!'

    expect(page).to have_text('Import enqueued')
  end

  scenario 'Create guide and import collaborators' do
    allow_any_instance_of(WithGitAccess).to receive(:collaborators).and_return([])

    click_on 'Import/Export'

    click_on 'Refresh collaborators!'

    expect(page).to have_text('Collaborators list refreshed')
  end


  scenario 'Create guide manually and the export flow' do
    click_on 'Info'

    fill_in 'guide_description', with: 'a description'

    within '#info-panel' do
      click_on 'Update Guide'
    end

    click_on 'Import/Export'

    click_on 'Export now!'

    expect(page).to have_text('Export queued')
  end

end
