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
      guide.update_collaborators!
    end

    it { expect(guide.collaborators).to eq [author] }

  end

  describe '#next_guides' do
    let(:path) { create(:path) }
    context 'when guide is not in path' do
      it { expect(guide.next_guides).to eq [] }
    end
    context 'when guide is in path' do
      let(:guide_in_path) { create(:guide, path: path, position: 2) }
      context 'when it is single' do
        it { expect(guide_in_path.next_guides).to eq [] }
      end
      context 'when there is a next guide' do
        let(:other_guide) { create(:guide, path: path, position: 3) }
        it { expect(guide_in_path.next_guides).to eq [other_guide] }
      end
      context 'when there are many next guides at same level' do
        let(:other_guide_1) { create(:guide, path: path, position: 3) }
        let(:other_guide_2) { create(:guide, path: path, position: 3) }
        it { expect(guide_in_path.next_guides).to eq [other_guide_1, other_guide_2] }
      end
    end
  end

  describe 'contributors' do
    let(:contributors_resource) {
      [{type: 'User', login: 'foo'}, {type: 'User', login: 'ignatiusReilly'}, {type: 'User', login: 'rigoberto88'}]
    }
    before do
      allow_any_instance_of(WithGitAccess).to receive(:contributors).and_return(contributors_resource)
      guide.update_contributors!
    end

    it { expect(guide.contributors).to eq [extra_user, author] }
  end


  describe '#new?' do
    context 'when just created' do
      it { expect(guide.new?).to be true }
    end
    context 'when created a month ago' do
      before { guide.update!(created_at: 1.month.ago) }

      it { expect(guide.new?).to be false }
    end
  end


  describe '#submission_contents_for' do
    before do
      guide.exercises = [create(:exercise, language: guide.language), create(:exercise, language: guide.language)]
      guide.save!
    end

    context 'when no submission' do
      it { expect(guide.solution_contents_for(extra_user)).to eq [] }
    end
    context 'when there are submissions' do
      before do
        guide.exercises.first.submit_solution(extra_user, content: 'foo1')
        guide.exercises.first.submit_solution(extra_user, content: 'foo2')
        guide.exercises.second.submit_solution(extra_user, content: 'bar')
      end
      it { expect(guide.solution_contents_for(extra_user)).to eq %w(foo2 bar) }
    end
  end
end
