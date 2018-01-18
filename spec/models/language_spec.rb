require 'spec_helper'

describe Language do
  let!(:gobstones) { create(:language, name: 'Gobstones') }

  it { expect { create :language, name: 'gobstones' }.to raise_exception(ActiveRecord::RecordInvalid) }
  it { expect(Language.for_name 'gobstones').to eq gobstones }
  it { expect(Language.for_name nil).to be nil}

  describe '#import!' do
    let(:ruby) { create(:language, name: 'ruby') }
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

    before { allow_any_instance_of(Mumukit::Bridge::Runner).to receive(:info).and_return response }
    before { ruby.import! }

    it { expect(ruby.name).to eq 'ruby' }
    it { expect(ruby.queriable).to be true }
    it { expect(ruby.output_content_type).to eq Mumukit::ContentType::Markdown }
    it { expect(ruby.visible_success_output).to be false }
    it { expect(ruby.highlight_mode).to eq 'ruby' }
    it { expect(ruby.devicon).to eq 'ruby' }
    it { expect(ruby.prompt).to eq '> ' }
    it { expect(ruby.stateful_console).to be true }
  end

  describe '#import!' do
    let(:gobstones) { create(:language, name: 'gobstones', runner_url: 'runner.com') }
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

    before { allow_any_instance_of(Mumukit::Bridge::Runner).to receive(:info).and_return response }
    before { gobstones.import! }

    it { expect(gobstones.name).to eq 'gobstones' }
    it { expect(gobstones.queriable).to be false }
    it { expect(gobstones.output_content_type).to eq Mumukit::ContentType::Html }
    it { expect(gobstones.visible_success_output).to be true }
    it { expect(gobstones.highlight_mode).to eq 'gobstones' }
    it { expect(gobstones.devicon).to eq 'gobstones' }
    it { expect(gobstones.prompt).to eq 'ム ' }
    it { expect(gobstones.stateful_console).to be false }
    it { expect(gobstones.layout_js_urls).to eq ['runner.com/javascripts/a.js'] }
    it { expect(gobstones.layout_html_urls).to eq ['runner.com/b.html', 'runner.com/c.html'] }
    it { expect(gobstones.layout_css_urls).to eq ['runner.com/stylesheets/d.css'] }
    it { expect(gobstones.editor_js_urls).to eq ['runner.com/javascripts/aa.js'] }
    it { expect(gobstones.editor_html_urls).to eq ['runner.com/bb.html', 'runner.com/cc.html'] }
    it { expect(gobstones.editor_css_urls).to eq ['runner.com/stylesheets/dd.css'] }
  end
end
