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
    it { expect(t_expectation_result('foo', 'Not:HasUsage:baz')).to eq('foo no debe utilizar baz') }
    it { expect(t_expectation_result('foo', 'Not:HasLambda')).to eq('foo no debe emplear expresiones lambda') }
  end
end
