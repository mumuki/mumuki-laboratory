require 'spec_helper'

describe IconsHelper do
  helper IconsHelper
  helper FontAwesome::Rails::IconHelper

  describe '#language_icon' do
    let(:haskell) { create(:language, name: 'Haskell') }
    let(:haskell_img_tag) { '<span alt="Haskell" class="fa da da-haskell lang-icon" />' }
    it { expect(language_icon(haskell)).to include haskell_img_tag }
  end

  describe '#status_icon' do
    let(:passed_submission) { create(:assignment, status: :passed, expectation_results: []) }
    let(:failed_submission) { create(:assignment, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fa fa-check-circle text-success status-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fa fa-times-circle text-danger status-icon"></i>' }
  end
end
