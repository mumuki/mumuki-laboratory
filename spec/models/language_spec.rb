require 'spec_helper'

describe Language do
  describe 'name uniqness' do
    let!(:gobstones) { create(:language, name: 'Gobstones') }

    it { expect { create :language, name: 'gobstones' }.to raise_exception(ActiveRecord::RecordInvalid) }
    it { expect(Language.for_name 'gobstones').to eq gobstones }
    it { expect(Language.for_name nil).to be nil}
  end

  describe '#import!' do
    subject { create(:language, name: 'gobstones', runner_url: 'http://runner.com') }
    before { subject.import_from_resource_h! language_resource_h }

    let(:language_resource_h) { {
      name: "gobstones",
      comment_type: nil,
      runner_url: "http://foo",
      output_content_type: "html",
      prompt: "ム ",
      extension: "gbs",
      highlight_mode: "gobstones",
      visible_success_output: true,
      devicon: nil,
      triable: false,
      feedback: true,
      queriable: false,
      stateful_console: false,
      test_extension: "yml",
      test_template: nil,
      layout_js_urls: ['http://runner.com/javascripts/a.js'],
      layout_html_urls: ["http://runner.com/b.html", "http://runner.com/c.html"],
      layout_css_urls: ["http://runner.com/stylesheets/d.css"],
      editor_js_urls: ['http://runner.com/javascripts/aa.js'],
      editor_html_urls: ["http://runner.com/bb.html", "http://runner.com/cc.html"],
      editor_css_urls: ["http://runner.com/stylesheets/dd.css"]
    } }

    it { expect(subject.name).to eq 'gobstones' }
    it { expect(subject.queriable).to be false }
    it { expect(subject.output_content_type).to eq Mumukit::ContentType::Html }
    it { expect(subject.visible_success_output).to be true }
    it { expect(subject.highlight_mode).to eq 'gobstones' }
    it { expect(subject.devicon).to eq 'gobstones' }
    it { expect(subject.prompt).to eq 'ム ' }
    it { expect(subject.stateful_console).to be false }
    it { expect(subject.feedback).to be true }
    it { expect(subject.layout_js_urls).to eq ['http://runner.com/javascripts/a.js'] }
    it { expect(subject.layout_html_urls).to eq ['http://runner.com/b.html', 'http://runner.com/c.html'] }
    it { expect(subject.layout_css_urls).to eq ['http://runner.com/stylesheets/d.css'] }
    it { expect(subject.editor_js_urls).to eq ['http://runner.com/javascripts/aa.js'] }
    it { expect(subject.editor_html_urls).to eq ['http://runner.com/bb.html', 'http://runner.com/cc.html'] }
    it { expect(subject.editor_css_urls).to eq ['http://runner.com/stylesheets/dd.css'] }
  end
end
