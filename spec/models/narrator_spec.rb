require 'spec_helper'

class Mumukit::Assistant::Narrator
  def initialize(seed)
    @seed = seed
  end

  def retry_phrase
    t :retry
  end

  def explanation_introduction_phrase
    t :introduction
  end

  def compose_explanation(tips)
    "#{explanation_introduction_phrase}\n\n#{explanation_paragraphs(tips).join("\n\n")}\n\n#{retry_phrase}\n"
  end

  def explanation_paragraphs(tips)
    tips.take(3).zip([:opening, :middle, :ending]).map do |tip, selector|
      send "explanation_#{selector}_paragraph", tip
    end
  end

  def explanation_opening_paragraph(tip)
    "#{tip.capitalize}."
  end

  def explanation_middle_paragraph(tip)
    t :middle, tip: tip
  end

  def explanation_ending_paragraph(tip)
    t :ending, tip: tip
  end

  def self.sample
    new retry: sample_index,
        introduction: sample_index,
        opening: sample_index,
        middle: sample_index,
        ending: sample_index
  end

  private

  def t(key, args={})
    I18n.t "narrator.#{key}_#{@seed[key]}", args
  end

  def self.sample_index
    (0..2).sample
  end
end

describe 'narrator' do
  context 'en' do
    before { I18n.locale = :en }
    let(:narrator) { Mumukit::Assistant::Narrator.new(retry: 0, introduction: 0, opening: 0, middle: 0, ending: 0) }
    let(:tips) { [
      'check you have not mispelled `product`',
      'check that you are using composition',
      'remeber that `sum` must work with both `Int`s and `Float`s'
    ] }

    it { expect(narrator.retry_phrase).to eq 'Let\'s try again!' }
    it { expect(narrator.explanation_introduction_phrase).to eq 'Oops, it didn\'t work :frowned:.' }
    it { expect(narrator.compose_explanation tips).to eq "Oops, it didn\'t work :frowned:.\n\n"+
                                                        "Check you have not mispelled `product`.\n\n"+
                                                        "Also, check that you are using composition.\n\n" +
                                                        "Finally, remeber that `sum` must work with both `Int`s and `Float`s.\n\n" +
                                                        "Let's try again!\n" }
  end

  context 'es' do
    before { I18n.locale = :es }
    let(:narrator) { Mumukit::Assistant::Narrator.new(retry: 0, introduction: 0, opening: 0, middle: 0, ending: 0) }

    it { expect(narrator.retry_phrase).to eq '¡Intentemos de nuevo!' }
    it { expect(narrator.explanation_introduction_phrase).to eq 'Parece que algo no funcionó :see_no_evil:.' }

    context '3 tips' do
      let(:tips) { [
        'fijate que no hayas escrito mal `product`',
        'fijate que estés usando composición',
        'recordá que `sum` debe funcionar tanto para `Int`s como `Float`s'
      ] }

      it { expect(narrator.compose_explanation tips).to eq "Parece que algo no funcionó :see_no_evil:.\n\n"+
                                                          "Fijate que no hayas escrito mal `product`.\n\n"+
                                                          "Además, fijate que estés usando composición.\n\n" +
                                                          "Por último, recordá que `sum` debe funcionar tanto para `Int`s como `Float`s.\n\n" +
                                                          "¡Intentemos de nuevo!\n" }
    end

    context '2 tips' do
      let(:tips) { [
        'fijate que no hayas escrito mal `product`',
        'fijate que estés usando composición'
      ] }

      it { expect(narrator.compose_explanation tips).to eq "Parece que algo no funcionó :see_no_evil:.\n\n"+
                                                          "Fijate que no hayas escrito mal `product`.\n\n"+
                                                          "Además, fijate que estés usando composición.\n\n" +
                                                          "¡Intentemos de nuevo!\n" }
    end
  end
end