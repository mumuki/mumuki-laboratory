require 'spec_helper'

describe 'import-export' do
  let(:committer) { create(:user, token: '123456') }
  let(:haskell) { create(:haskell) }
  let!(:exercise_1) { create(:problem, guide: guide, name: 'Foo', position: 2,
                             locale: 'en', tag_list: %w(foo bar), language: haskell) }
  let!(:exercise_2) { create(:problem, guide: guide, name: 'Bar', position: 1,
                             description: 'a description', test: 'foo bar',
                             tag_list: %w(baz bar),
                             language: haskell,
                             layout: :no_editor) }
  let!(:exercise_3) { create(:playground, guide: guide, name: 'Baz', position: 3,
                             tag_list: %w(baz bar),
                             language: haskell,
                             layout: :editor_bottom) }
  let(:guide) { create(:guide,
                       description: 'Baz',
                       github_repository: 'flbulgarelli/never-existent-repo',
                       language: haskell,
                       locale: 'en') }

  let(:dir) { 'spec/data/import-export' }

  before do
    FileUtils.mkdir_p dir

    guide.exports.create!(committer: committer).write_guide! dir
    guide.exercises.delete_all
    guide.update!(description: '***', locale: 'es', language: nil)
    @log = guide.imports.create!(committer: committer).read_guide! dir
    guide.reload
  end

  after do
    FileUtils.rm_rf dir
  end

  it { expect(@log.to_s).to eq '' }
  it { expect(guide.exercises.length).to eq 3 }
  it { expect(guide.exercises.first.name).to eq 'Bar' }
  it { expect(guide.exercises.second.name).to eq 'Foo' }
  it { expect(guide.exercises.third.name).to eq 'Baz' }
  it { expect(guide.exercises.first.layout).to eq 'no_editor' }
  it { expect(guide.exercises.second.layout).to eq 'editor_right' }

  it { expect(guide.language).to eq haskell }
  it { expect(guide.locale).to eq 'en' }
  it { expect(guide.description).to eq 'Baz' }


end
