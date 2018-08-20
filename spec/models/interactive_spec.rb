require 'spec_helper'

describe Interactive, organization_workspace: :test do
  let!(:interactive) { create(:interactive) }
  let!(:user) { create(:user) }
  let(:assignment) { interactive.assignment_for(user) }
  let!(:bridge) { double(:bridge) }
  before { allow_any_instance_of(Language).to receive(:bridge).and_return bridge }

  context 'before even trying' do
    it { expect(assignment.queries).to eq [] }
    it { expect(assignment.query_results).to be_blank }
    it { expect(assignment.status).to eq :pending }
    it { expect(assignment.result).to be_blank }
  end

  context 'on first, failing try' do
    before do
      expect(bridge)
        .to receive(:run_try!).and_return status: :failed,
                                          result: '',
                                          query_result: {
                                            status: :passed,
                                            result: 'foo out'
                                          }

    end

    before { interactive.submit_try!(user, query: 'foo') }

    it { expect(assignment.queries).to eq ['foo'] }
    it { expect(assignment.query_results).to eq [{status: :passed, result: "foo out"}] }
    it { expect(assignment.queries_with_results).to eq [{query: 'foo', status: :passed, result: "foo out"}] }
    it { expect(assignment.status).to eq :failed }
    it { expect(assignment.result).to eq '' }
  end

  context 'on second, failing try' do
    before do
      expect(bridge)
        .to receive(:run_try!).and_return({status: :failed,
                                           result: '',
                                           query_result: { status: :passed, result: 'foo out' }},
                                          {status: :failed,
                                           result: '',
                                           query_result: { status: :failed, result: 'bar out' }})

    end


    before do
      interactive.submit_try!(user, query: 'foo')
      interactive.submit_try!(user, query: 'bar', cookie: ['foo'])
    end

    it { expect(assignment.queries).to eq ['foo', 'bar'] }
    it { expect(assignment.query_results).to eq [
                                                {status: :passed, result: 'foo out'},
                                                {status: :failed, result: 'bar out'}] }
    it { expect(assignment.queries_with_results).to eq [
                                                {query: 'foo', status: :passed, result: 'foo out'},
                                                {query: 'bar', status: :failed, result: 'bar out'}] }

    it { expect(assignment.status).to eq :failed }
    it { expect(assignment.result).to be_blank }
  end

  context 'on third, passing try' do
    before do
      expect(bridge)
        .to receive(:run_try!).and_return({status: :failed,
                                           result: '',
                                           query_result: { status: :passed, result: 'foo out' }},
                                          {status: :failed,
                                           result: '',
                                           query_result: { status: :failed, result: 'bar out' }},
                                          {status: :passed,
                                           result: 'foobaz',
                                           query_result: { status: :passed, result: 'baz out' }})

    end


    before do
      interactive.submit_try!(user, query: 'foo')
      interactive.submit_try!(user, query: 'bar', cookie: ['foo'])
      interactive.submit_try!(user, query: 'baz', cookie: ['foo', 'bar'])
    end

    it { expect(assignment.queries).to eq ['foo', 'bar', 'baz'] }
    it { expect(assignment.query_results).to eq [
                                                {status: :passed, result: 'foo out'},
                                                {status: :failed, result: 'bar out'},
                                                {status: :passed, result: 'baz out'}] }
    it { expect(assignment.status).to eq :passed }
    it { expect(assignment.result).to eq 'foobaz' }
  end


  context 'on first failing try after reset' do
    before do
      expect(bridge)
        .to receive(:run_try!).and_return({status: :failed,
                                           result: '',
                                           query_result: { status: :passed, result: 'foo out' }},
                                          {status: :failed,
                                           result: '',
                                           query_result: { status: :failed, result: 'bar out' }},
                                          {status: :failed,
                                           result: '',
                                           query_result: { status: :failed, result: 'goo out' }})

    end


    before do
      interactive.submit_try!(user, query: 'foo')
      interactive.submit_try!(user, query: 'bar', cookie: ['foo'])
      interactive.submit_try!(user, query: 'goo')
    end

    it { expect(assignment.queries).to eq ['goo'] }
    it { expect(assignment.query_results).to eq [{status: :failed, result: 'goo out'}] }
    it { expect(assignment.status).to eq :failed }
    it { expect(assignment.result).to be_blank }
  end

  context 'on aborted try with no query_result' do
    before do
      expect(bridge).to receive(:run_try!).and_return({status: :aborted, result: ''})
    end

    before do
      interactive.submit_try!(user, query: 'foo')
    end

    it { expect(assignment.queries).to eq ['foo'] }
    it { expect(assignment.query_results).to eq [] }
    it { expect(assignment.status).to eq :aborted }
    it { expect(assignment.result).to eq 'Oops, something went wrong in Mumuki. Restart the exercise, wait a few seconds and try again.'}
  end

end
