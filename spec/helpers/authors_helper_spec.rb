require 'spec_helper'

describe AuthorsHelper, organization_workspace: :test do
  helper AuthorsHelper

  describe 'authoring_notes' do
    context 'with collaborators' do
      let(:guide) { create(:guide, authors: 'Writer', collaborators: 'Collaborators') }
      it { expect(attribution_caption(guide)).to include "many others" }
    end
    
    context 'with no collaborators' do
      let(:guide) { create(:guide, authors: 'Writer') }
      it { expect(attribution_caption(guide)).not_to include "many others" }
    end

  end
end
