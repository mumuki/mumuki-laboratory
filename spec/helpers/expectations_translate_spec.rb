require 'spec_helper'

describe ExpectationsTranslate do
  helper ExpectationsTranslate

  context 'en locale' do
    before { I18n.locale = :en }

    it { expect(t_expectation_result('foo', 'HasBinding')).to eq('<strong>foo</strong> must be defined') }
    it { expect(t_expectation_result('foo', 'Not:HasUsage:baz')).to eq('<strong>foo</strong> must not use <strong>baz</strong>') }
    it { expect(t_expectation_result('foo', 'Not:HasLambda')).to eq('<strong>foo</strong> must not use lambda expressions') }
  end

  context 'es locale' do
    before { I18n.locale = :es }

    it { expect(t_expectation_result('foo', 'HasBinding')).to eq('<strong>foo</strong> debe estar definido') }
    it { expect(t_expectation_result('foo', 'Not:HasUsage:baz')).to eq('<strong>foo</strong> no debe utilizar <strong>baz</strong>') }
    it { expect(t_expectation_result('foo', 'Not:HasLambda')).to eq('<strong>foo</strong> no debe emplear expresiones lambda') }
  end
end
