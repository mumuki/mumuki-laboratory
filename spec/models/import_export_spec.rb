require 'spec_helper'

describe 'import-export' do
  let(:committer) { create(:user, token: '123456') }
  let(:haskell) { create(:haskell) }
  let!(:exercise_1) { create(:exercise, guide: guide, title: 'Foo', position: 2,
                             locale: 'en', tag_list: %w(foo bar), language: haskell) }
  let!(:exercise_2) { create(:exercise, guide: guide, title: 'Bar', position: 1,
                             description: 'a description', test: 'foo bar',
                             tag_list: %w(baz bar), language: haskell) }
  let(:guide) { create(:guide, description: 'Baz', github_repository: 'flbulgarelli/never-existent-repo', language: haskell, locale: 'en') }

  let(:dir) { 'spec/data/import-export' }

  before do
    FileUtils.mkdir_p dir

    guide.exports.create!(committer: committer).write_guide! dir
    guide.exercises.delete_all
    guide.update!(description: '***', locale: 'es', language: nil)
    guide.imports.create!.read_guide! dir
    guide.reload
  end

  after do
    FileUtils.rm_rf dir
  end

  it { expect(guide.exercises.length).to eq 2 }
  it { expect(guide.exercises.first.title).to eq 'Bar' }
  it { expect(guide.exercises.second.title).to eq 'Foo' }

  it { expect(guide.language).to eq haskell }
  it { expect(guide.locale).to eq 'en' }
  it { expect(guide.description).to eq 'Baz' }


end
