require 'spec_helper'

describe Mumukit::Auth::Metadata do
  let(:metadata) do
    Mumukit::Auth::Metadata.new(
        {atheneum: {permissions: 'foo/*:test/*'},
         admin: {permissions: 'test/*'},
         classroom: {permissions: 'foo/baz'}}.deep_stringify_keys)
  end

  it { expect(metadata.teacher? 'foobar/baz').to be false }
  it { expect(metadata.teacher? 'foo/baz').to be true }

  it { expect(metadata.admin? 'test/atheneum').to be true }

  it { expect(metadata.librarian? 'test/atheneum').to be false }

  it { expect(metadata.student? 'test/atheneum').to be true }
  it { expect(metadata.student? 'foo/atheneum').to be true }
  it { expect(metadata.student? 'baz/atheneum').to be false }

  it { expect(Mumukit::Auth::Token.from_env({}).metadata.student? 'foo/bar').to be false }
end
