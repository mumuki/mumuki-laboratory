require 'spec_helper'

describe CommentsController do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }

  before do
    assignment = exercise.submit_solution! user, content: ''
    10.times do
      assignment.comment! exercise_id: 1,
                          content: 'a',
                          type: 'success',
                          date: '1/1/1',
                          author: 'aguspina87@gmail.com'
    end
  end

  before { set_current_user! user }
  before { get :index }

  it { expect(response.status).to eq 200 }
  it { expect(response.body).to json_eq(has_comments: true, comments_count: 10) }
end
