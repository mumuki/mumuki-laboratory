require 'spec_helper'

describe Comment do
  describe '#parse_json' do
    let(:data) do
      {'exercise_id' => 1, 'submission_id' => 1, 'comment' => {'email' => 'aguspina87@gmail.com', 'content' => 'a', 'type' => 'success', 'date' => '1/1/1' }}
    end
    let(:expected_json) {
      {
        'exercise_id'=> 1, 'submission_id'=> 1, 'content'=> 'a', 'type'=> 'success', 'date'=> '1/1/1', 'author'=> 'aguspina87@gmail.com'
      }
    }
    let(:parsed_comment) { Comment.parse_json(data) }

    it { expect(parsed_comment).to eq(expected_json) }

  end
end
