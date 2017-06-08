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
      {'submission_id' => 'abcdef1',
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
      let(:final_assignment) { Assignment.first }
      let(:message) { Message.first }

      let!(:data) {
        {'exercise_id' => problem.id,
         'submission_id' => assignment.submission_id,
         'organization' => Organization.current.name,
         'message' => {
           'sender' => 'teacher@mumuki.org',
           'content' => 'a',
           'created_at' => '1/1/1'}} }

      before { Message.import_from_json! data }
      before do
        assignment2 = problem.submit_solution! user, content: ''
        data2 = {'exercise_id' => problem.id,
                 'submission_id' => assignment2.submission_id,
                 'organization' => Organization.current.name,
                 'message' => {
                   'sender' => 'teacher@mumuki.org',
                   'content' => 'a',
                   'created_at' => '1/1/1'}}
        Message.import_from_json! data2
      end

      it { expect(Message.count).to eq 1 }
      it { expect(message.assignment).to_not be_nil }
      it { expect(message.assignment).to eq final_assignment }
      it { expect(final_assignment.has_messages?).to be true }
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

      it { expect(Message.count).to eq 0 }
      it { expect(Assignment.first.has_messages?).to be false }
    end

  end
end
