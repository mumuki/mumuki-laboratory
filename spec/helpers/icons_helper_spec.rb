require 'spec_helper'

describe IconsHelper, organization_workspace: :test do
  helper IconsHelper
  helper FontAwesome5::Rails::IconHelper

  describe '#language_icon' do
    let(:haskell) { create(:language, name: 'Haskell') }
    let(:haskell_img_tag) { '<span class="fa da da-haskell lang-icon" alt="Haskell" />' }
    it { expect(language_icon(haskell)).to include haskell_img_tag }
  end

  describe '#status_icon' do
    let(:passed_submission) {
      create(:assignment, status: :passed, expectation_results: [], exercise: create(:indexed_exercise))
    }
    let(:failed_submission) { create(:assignment, status: :failed) }

    it { expect(status_icon(passed_submission)).to eq '<i class="fas fa-check-circle text-success status-icon"></i>' }
    it { expect(status_icon(failed_submission)).to eq '<i class="fas fa-times-circle text-danger status-icon"></i>' }
  end
end
