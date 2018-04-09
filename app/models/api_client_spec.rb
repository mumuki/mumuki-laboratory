require 'rails_helper'

describe ApiClient, type: :model do
  let(:api_client) {create :api_client}
  it {expect { Mumukit::Auth::Token.decode(api_client.token).verify_client!}.to_not raise_error }
end
