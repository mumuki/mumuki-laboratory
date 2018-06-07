require 'spec_helper'

describe 'narrator' do
  describe 'random narrator' do
    let(:narrator) { Mumukit::Assistant::Narrator.random }

    it { expect(narrator).to be_a Mumukit::Assistant::Narrator }
    it { expect(narrator.retry_phrase).to be_a String }
  end

  describe 'seeded narrator' do
    let(:seed) { Mumukit::Assistant::Narrator.seed(0, 0, 0, 0, 0) }
    let(:narrator) { Mumukit::Assistant::Narrator.new(seed) }

    context 'en' do
      before { I18n.locale = :en }
      let(:tips) { [
        'check you have not mispelled `product`',
        'check that you are using composition',
        'remember that `sum` must work with both `Int`s and `Float`s'
      ] }

      it { expect(narrator.retry_phrase).to eq 'Let\'s try again!' }
      it { expect(narrator.explanation_introduction_phrase).to eq 'Oops, it didn\'t work :frowning:.' }
      it { expect(narrator.compose_explanation tips).to eq "Oops, it didn\'t work :frowning:.\n\n"+
                                                          "Check you have not mispelled `product`.\n\n"+
                                                          "Also, check that you are using composition.\n\n" +
                                                          "Finally, remember that `sum` must work with both `Int`s and `Float`s.\n\n" +
                                                          "Let's try again!\n" }
    end

    context 'es' do
      before { I18n.locale = :es }
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
end
