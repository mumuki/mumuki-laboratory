require 'spec_helper'

describe Guide do
  let(:author) { create(:user, name: 'rigoberto88') }
  let!(:extra_user) { create(:user, name: 'ignatiusReilly') }
  let(:guide) { create(:guide, github_repository: 'flbulgarelli/mumuki-sample-exercises', author: author) }

  it { expect(guide.github_url).to eq 'https://github.com/flbulgarelli/mumuki-sample-exercises' }

  it { expect(guide.github_repository_name).to eq 'mumuki-sample-exercises' }

  describe 'collaborators' do
    let(:collaborators_resource) {
      [{type: 'User', login: 'foo'}, {type: 'User', login: 'rigoberto88'}]
    }
    before do
      allow_any_instance_of(WithGitAccess).to receive(:collaborators).and_return(collaborators_resource)
    end

    it { expect(guide.collaborators).to eq [author] }

  end

  describe 'contributors' do
    let(:contributors_resource) {
      [{type: 'User', login: 'foo'}, {type: 'User', login: 'ignatiusReilly'}, {type: 'User', login: 'rigoberto88'}]
    }
    before do
      allow_any_instance_of(WithGitAccess).to receive(:contributors).and_return(contributors_resource)
    end

    it { expect(guide.contributors).to eq [extra_user, author] }
  end

end
