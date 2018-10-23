require 'spec_helper'

describe Guide do
  let!(:haskell) { create(:haskell) }
  let!(:gobstones) { create(:gobstones) }

  let!(:lesson_1) { create(:lesson, name: 'l1') }
  let(:guide_1) { lesson_1.guide }

  let!(:lesson_2) { create(:lesson, name: 'l2') }

  let!(:guide_2) { create(:guide, name: 'g2') }
  let!(:guide_3) { create(:guide, name: 'g3') }

  let(:topic_json) do
    {name: 'sample topic',
     description: 'topic description',
     slug: 'mumuki/mumuki-sample-topic',
     locale: 'en',
     lessons: [guide_2, guide_1, guide_3].map(&:slug)}.deep_stringify_keys
  end

  describe '#import_from_resource_h!' do
    context 'when guide is empty' do
      let(:topic) { create(:topic, lessons: [lesson_1, lesson_2]) }

      before do
        topic.import_from_resource_h!(topic_json)
      end

      it { expect(topic.name).to eq 'sample topic' }
      it { expect(topic.description).to eq 'topic description' }
      it { expect(topic.locale).to eq 'en' }
      it { expect(topic.lessons.count).to eq 3 }
      it { expect(topic.lessons.first.guide).to eq guide_2 }
      it { expect(topic.lessons.second).to eq lesson_1 }
      it { expect(topic.lessons.third.guide).to eq guide_3 }
      it { expect(Guide.count).to eq 4 }
      it { expect(Lesson.count).to eq 3 }
    end
  end
end
