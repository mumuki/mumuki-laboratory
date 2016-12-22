require 'spec_helper'

describe Atheneum::Event::UserChanged do
  let(:user_json) {
    { user: {
      uid: 'foo@bar.com',
      first_name: 'Foo',
      last_name: 'Bar',
      permissions: {student: 'test/example'},
      id: 1
    }}
  }
  before { Atheneum::Event::UserChanged.execute! user_json }
  it {expect(User.first.uid).to eq 'foo@bar.com'}
  it {expect(User.first.name).to eq 'Foo Bar'}
  it {expect(User.first.student? 'test/example').to be true}
end
