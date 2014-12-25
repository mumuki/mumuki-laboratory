require 'spec_helper'

describe Guide do
  let(:user) { create(:user) }
  let(:guide) { Guide.new name: 'foo', author: user, github_repository: 'flbulgarelli/mumuki-sample-exercises' }

  it { expect(guide.github_url).to eq 'https://github.com/flbulgarelli/mumuki-sample-exercises' }
end
