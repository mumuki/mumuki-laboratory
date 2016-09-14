require 'spec_helper'

describe Comment do
  describe '#parse_json' do
    let(:data) {
      {'exercise_id' => 1,
       'submission_id' => 'abcdef1',
       'social_id' => 'auth0|dfdsfsdfsd',
       'comment' => {
           'email' => 'aguspina87@gmail.com',
           'content' => 'a',
           'type' => 'success',
           'date' => '1/1/1'}} }

    let(:expected_json) {
      {'exercise_id' => 1,
       'submission_id' => 'abcdef1',
       'content' => 'a',
       'type' => 'success',
       'date' => '1/1/1',
       'author' => 'aguspina87@gmail.com'} }

    let(:parsed_comment) { Comment.parse_json(data) }

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
         'social_id' => 'auth0|dfdsfsdfsd',
         'tenant' => Organization.current.name,
         'comment' => {
             'email' => 'teacher@mumuki.org',
             'content' => 'a',
             'type' => 'success',
             'date' => '1/1/1'}} }
      before { Comment.import_from_json! data }

      it { expect(Comment.count).to eq 1 }
      it { expect(Comment.first.assignment).to_not be_nil }
      it { expect(Comment.first.assignment).to eq assignment }
    end

    context 'when not last submission' do
      let!(:assignment) { problem.submit_solution! user, content: '' }
      let!(:data) {
        {'exercise_id' => problem.id,
         'submission_id' => assignment.submission_id,
         'tenant' => Organization.current.name,
         'comment' => {
             'email' => 'teacher@mumuki.org',
             'content' => 'a',
             'type' => 'success',
             'date' => '1/1/1'}} }

      before { problem.submit_solution! user, content: 'other solution' }
      before { Comment.import_from_json! data }

      it { expect(Comment.count).to eq 1 }
      it { expect(Comment.first.assignment).to be_nil }
    end

  end
end
