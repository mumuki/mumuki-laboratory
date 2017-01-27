require 'spec_helper'

describe Laboratory::Event::UserChanged do
  let(:user) { User.find_by(uid: 'foo@bar.com') }
  let(:user_json) {
    {user: {
      uid: 'foo@bar.com',
      first_name: 'Foo',
      last_name: 'Bar',
      permissions: {student: 'test/example'},
      id: 1
    }}
  }
  context 'when new user' do
    before { Laboratory::Event::UserChanged.execute! user_json }
    it { expect(user.uid).to eq 'foo@bar.com' }
    it { expect(user.name).to eq 'Foo Bar' }
    it { expect(user.student?).to be true }
  end

  context 'when user exists' do
    let(:new_json) {
      {user: {
        uid: 'foo@bar.com',
        first_name: 'Foo',
        last_name: 'Baz',
        permissions: {student: 'test/example2'},
        id: 1
      }}
    }
    before { Laboratory::Event::UserChanged.execute! user_json }
    before { Laboratory::Event::UserChanged.execute! new_json }
    it { expect(user.name).to eq 'Foo Baz' }
    it { expect(user.student?).to be true }
    it { expect(user.permissions.student? 'test/example2').to be true }
    it { expect(user.permissions.student? 'test/example').to be false }
  end
end
