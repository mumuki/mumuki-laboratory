require 'spec_helper'

describe Message do
  describe '#parse_json' do
    let(:data) {
      {'exercise_id' => 1,
       'submission_id' => 'abcdef1',
       'message' => {
         'sender' => 'aguspina87@gmail.com',
         'content' => 'a',
         'created_at' => '1/1/1'}} }

    let(:expected_json) {
      {'exercise_id' => 1,
       'submission_id' => 'abcdef1',
       'content' => 'a',
       'created_at' => '1/1/1',
       'sender' => 'aguspina87@gmail.com'} }

    let(:parsed_comment) { Message.parse_json(data) }

    it { expect(parsed_comment).to eq(expected_json) }
  end

  describe '.import_from_json!' do
    let(:user) { create(:user) }
    let(:problem) { create(:problem) }

    context 'when last submission' do
      let!(:assignment) { problem.submit_solution! user, content: '' }
      let!(:data) {
        {'exercise_id' => problem.id,
         'submission_id' => assignment.submission_id,
         'organization' => Organization.current.name,
         'message' => {
           'sender' => 'teacher@mumuki.org',
           'content' => 'a',
           'created_at' => '1/1/1'}} }
      before { Message.import_from_json! data }

      it { expect(Message.count).to eq 1 }
      it { expect(Message.first.assignment).to_not be_nil }
      it { expect(Message.first.assignment).to eq assignment }
    end

    context 'when not last submission' do
      let!(:assignment) { problem.submit_solution! user, content: '' }
      let!(:data) {
        {'exercise_id' => problem.id,
         'submission_id' => assignment.submission_id,
         'organization' => Organization.current.name,
         'message' => {
           'sender' => 'teacher@mumuki.org',
           'content' => 'a',
           'type' => 'success',
           'created_at' => '1/1/1'}} }

      before { problem.submit_solution! user, content: 'other solution' }
      before { Message.import_from_json! data }

      it { expect(Message.count).to eq 1 }
      it { expect(Message.first.assignment).to be_nil }
    end

  end
end
