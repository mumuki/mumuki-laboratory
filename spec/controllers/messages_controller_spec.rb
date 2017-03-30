require 'spec_helper'

describe MessagesController do
  let(:user) { create(:user) }
  let(:exercise) { create(:exercise) }

  before do
    assignment = exercise.submit_solution! user, content: ''
    10.times do
      assignment.message! content: 'a',
                          type: 'success',
                          date: '1/1/1',
                          sender: 'aguspina87@gmail.com'
    end
  end

  context 'when  not authenticated' do
    before { get :index }

    it { expect(response.status).to eq 403 }
  end

  context 'when authenticated' do
    before { set_current_user! user }
    before { get :index }

    it { expect(response.status).to eq 200 }
    it { expect(response.body.parse_json).to json_like(has_messages: true, messages_count: 10) }
  end
end
