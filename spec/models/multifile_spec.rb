require 'spec_helper'

describe SubmissionFileset do
  let(:exercise) { create(:exercise) }
  let(:user) { create(:user) }
  let(:content) do
    SubmissionFileset.new(fileset: {
      foo: { content: 'puts foo' },
      bar: { content: 'puts bar' }
    })
  end

  before { exercise.submit_solution!(user, content: content) }

  it do
    files = exercise.assignment_for(user).solution
    expect(files.fileset[:foo][:content]).to eq 'puts foo'
    expect(files.fileset[:bar][:content]).to eq 'puts bar'
  end

end
