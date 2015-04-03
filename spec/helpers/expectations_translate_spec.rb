require 'spec_helper'

describe ExpectationsTranslate do
  helper ExpectationsTranslate

  context 'en locale' do
    before { I18n.locale = :en }

    it { expect(t_expectation_result('foo', 'HasBinding')).to eq('foo must be defined') }
    it { expect(t_expectation_result('foo', 'Not:HasUsage:baz')).to eq('foo must not use baz') }
    it { expect(t_expectation_result('foo', 'Not:HasLambda')).to eq('foo must not use lambda expressions') }
  end

  context 'es locale' do
    before { I18n.locale = :es }

    it { expect(t_expectation_result('foo', 'HasBinding')).to eq('foo debe estar definido') }
    it { expect(t_expectation_result('foo', 'Not:HasUsage:baz')).to eq('foo no debe definir baz') }
    it { expect(t_expectation_result('foo', 'Not:HasLambda')).to eq('foo no debe usar expresiones lambda') }
  end


  it { expect(parse_inspection('HasBinding')).to eq(inspection: 'HasBinding', type: 'must') }
  it { expect(parse_inspection('Not:HasBinding')).to eq(inspection: 'HasBinding', type: 'must_not') }
  it { expect(parse_inspection('HasUsage:m')).to eq(inspection: 'HasUsage', type: 'must', target: 'm') }
  it { expect(parse_inspection('Not:HasUsage:m')).to eq(inspection: 'HasUsage', type: 'must_not', target: 'm') }

end
