require 'spec_helper'

describe Language do
  describe 'name uniqness' do
    let!(:gobstones) { create(:language, name: 'Gobstones') }

    it { expect { create :language, name: 'gobstones' }.to raise_exception(ActiveRecord::RecordInvalid) }
    it { expect(Language.for_name 'gobstones').to eq gobstones }
    it { expect(Language.for_name nil).to be nil}
  end

  describe '#import!' do
    let(:bridge) { Mumukit::Bridge::Runner.new('http://runner.com') }
    before { expect(bridge).to receive(:info).and_return response }
    before { subject.import_from_resource_h! bridge.importable_info }

    context 'non graphical language' do
      subject { create(:language, name: 'ruby') }
      let(:response) do
      {
          'name' => 'ruby',
          'version' => 'master',
          'escualo_base_version' => nil,
          'escualo_service_version' => nil,
          'mumukit_version' => '1.0.1',
          'output_content_type' => 'markdown',
          'features' => {
              'query' => true,
              'expectations' => false,
              'feedback' => false,
              'secure' => false,
              'sandboxed' => true,
              'stateful' => true,
              'structured' => true
          },
          'language' => {
              'prompt' => '>',
              'name' => 'ruby',
              'version' => '2.0',
              'extension' => 'rb',
              'ace_mode' => 'ruby'
          },
          'test_framework' => {
              'name' => 'rspec',
              'version' => '2.13',
              'test_extension' => '.rb'
          },
          'url' => 'http://ruby.runners.mumuki.io/info'
      }
      end

      it { expect(subject.name).to eq 'ruby' }
      it { expect(subject.queriable).to be true }
      it { expect(subject.output_content_type).to eq Mumukit::ContentType::Markdown }
      it { expect(subject.visible_success_output).to be false }
      it { expect(subject.highlight_mode).to eq 'ruby' }
      it { expect(subject.devicon).to eq 'ruby' }
      it { expect(subject.prompt).to eq '> ' }
      it { expect(subject.stateful_console).to be true }
    end

    context 'graphical language' do
      subject { create(:language, name: 'gobstones', runner_url: 'http://runner.com') }
      let(:response) do
      {
          'name' => 'gobstones',
          'version' => 'master',
          'escualo_base_version' => nil,
          'escualo_service_version' => nil,
          'mumukit_version' => '1.0.1',
          'output_content_type' => 'html',
          'features' => {
              'query' => false,
              'expectations' => true,
              'feedback' => false,
              'secure' => false,
              'sandboxed' => false,
              'structured' => true
          },
          'layout_assets_urls' => {
              'js' => ['javascripts/a.js'],
              'html' => ['b.html', 'c.html'],
              'css' => ['stylesheets/d.css']
          },
          'editor_assets_urls' => {
              'js' => ['javascripts/aa.js'],
              'html' => ['bb.html', 'cc.html'],
              'css' => ['stylesheets/dd.css']
          },
          'language' => {
              'name' => 'gobstones',
              'graphic' => true,
              'version' => '1.4.1',
              'extension' => 'gbs',
              'ace_mode' => 'gobstones'
          },
          'test_framework' => {
              'name' => 'stones-spec',
              'test_extension' => 'yml'
          },
          'url' => 'http://runners2.mumuki.io:8001/info'
      }
      end

      it { expect(subject.name).to eq 'gobstones' }
      it { expect(subject.queriable).to be false }
      it { expect(subject.output_content_type).to eq Mumukit::ContentType::Html }
      it { expect(subject.visible_success_output).to be true }
      it { expect(subject.highlight_mode).to eq 'gobstones' }
      it { expect(subject.devicon).to eq 'gobstones' }
      it { expect(subject.prompt).to eq 'ム ' }
      it { expect(subject.stateful_console).to be false }
      it { expect(subject.layout_js_urls).to eq ['http://runner.com/javascripts/a.js'] }
      it { expect(subject.layout_html_urls).to eq ['http://runner.com/b.html', 'http://runner.com/c.html'] }
      it { expect(subject.layout_css_urls).to eq ['http://runner.com/stylesheets/d.css'] }
      it { expect(subject.editor_js_urls).to eq ['http://runner.com/javascripts/aa.js'] }
      it { expect(subject.editor_html_urls).to eq ['http://runner.com/bb.html', 'http://runner.com/cc.html'] }
      it { expect(subject.editor_css_urls).to eq ['http://runner.com/stylesheets/dd.css'] }
    end
  end
end
