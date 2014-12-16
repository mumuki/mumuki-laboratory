require 'spec_helper'

describe Authentication do
  include Authentication

  describe '#restricted_for_current_user' do
    let(:exercise) { create(:exercise) }
    let(:result) { restricted_to_current_user(exercise) { true } }

    def current_user
      _user
    end

    context 'when is current user' do
      let(:_user) { exercise.author }
      it { expect(result).to be_true }
    end

    context 'when is current user' do
      let(:_user) { create(:user) }
      it { expect(result).to be_nil }
    end
  end
end
