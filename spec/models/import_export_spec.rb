require 'spec_helper'

describe 'import-export' do
  let(:committer) { create(:user, token: '123456') }
  let(:haskell) { create(:haskell) }
  let!(:exercise_1) { create(:exercise, guide: guide,
                             title: 'Foo', original_id: 100, position: 1,
                             locale: 'en', tag_list: %w(foo bar),
                             language: haskell,
                             expectations: [Expectation.new(binding: 'bar', inspection: 'HasBinding')]) }
  let!(:exercise_2) { create(:exercise, guide: guide,
                             description: 'a description',
                             title: 'Bar', tag_list: %w(baz bar), original_id: 200, position: 2,
                             language: haskell, test: 'foo bar') }
  let(:guide) { create(:guide, description: 'Baz', github_repository: 'flbulgarelli/never-existent-repo', language: haskell, locale: 'en') }

  let(:dir) { 'spec/data/import-export' }

  before do
    FileUtils.mkdir_p dir

    #TODO naming not consistent
    guide.exports.create!(committer: committer).write_guide_files dir
    guide.exercises.delete_all
    guide.update!(description: '***', locale: 'es', language: nil)
    guide.imports.create!.run_import_from_directory! dir
    guide.reload
  end

  after do
    FileUtils.rm_rf dir
  end

  it { expect(guide.exercises.length).to eq 2 }
  it { expect(guide.exercises.first.title).to eq 'Foo' }
  it { expect(guide.exercises.second.title).to eq 'Bar' }

  it { expect(guide.language).to eq haskell }
  it { expect(guide.locale).to eq 'en' }
  it { expect(guide.description).to eq 'Baz' }


end
