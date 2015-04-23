require 'spec_helper'

describe Guide do
  let(:guide) { create(:guide, github_repository: 'flbulgarelli/mumuki-sample-exercises') }

  it { expect(guide.github_url).to eq 'https://github.com/flbulgarelli/mumuki-sample-exercises' }

  it { expect(guide.github_repository_name).to eq 'mumuki-sample-exercises' }
end
