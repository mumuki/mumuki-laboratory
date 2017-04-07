require 'spec_helper'

describe Api::TopicsController do
  describe 'post' do
    let(:imported_topic) { Topic.find_by(slug: 'mumuki/mumuki-topic-sample') }
    let(:guide) { create(:guide) }
    let(:topic_json) do
      {name: 'sample topic',
       description: 'topic description',
       slug: 'mumuki/mumuki-topic-sample',
       locale: 'en',
       lessons: [guide].map(&:slug)}.deep_stringify_keys
    end

    before { expect_any_instance_of(Mumukit::Bridge::Bibliotheca).to receive(:topic).and_return(topic_json) }
    before { post :create, {slug: 'mumuki/mumuki-topic-sample'} }

    it { expect(response.status).to eq 200 }
    it { expect(imported_topic).to_not be nil }
    it { expect(imported_topic.name).to eq 'sample topic' }
    it { expect(imported_topic.lessons.count).to eq 1 }
  end
end
