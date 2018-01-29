require 'spec_helper'

describe User do
  let(:user) { User.find_by(uid: 'foo@bar.com') }
  let(:user_json) { {
    uid: 'foo@bar.com',
    first_name: 'Foo',
    last_name: 'Bar',
    permissions: {student: 'test/example'},
    id: 1
  } }

  context 'when new user' do
    before { User.import_from_json! user_json }
    it { expect(user.uid).to eq 'foo@bar.com' }
    it { expect(user.name).to eq 'Foo Bar' }
    it { expect(user.student_here?).to be true }
  end

  context 'when user exists' do
    let(:new_json) { {
      uid: 'foo@bar.com',
      first_name: 'Foo',
      last_name: 'Baz',
      permissions: {student: 'test/example2'},
      id: 1
    } }
    before { User.import_from_json! user_json }
    before { User.import_from_json! new_json }
    it { expect(user.name).to eq 'Foo Baz' }
    it { expect(user.student_here?).to be true }
    it { expect(user.student? 'test/example2').to be true }
    it { expect(user.student? 'test/example').to be false }
  end
end
