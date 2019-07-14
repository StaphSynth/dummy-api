require 'spec_helper'

describe JsonWebToken, type: :service do
  describe '.encode'

  describe '.decode' do
    let(:token) { Faker::Internet.device_token }
    let(:user_data) { { user_id: 1 } }
    let(:decoded_jwt) { [user_data, { meta_data: 'meta data' }] }

    before do
      allow(JWT).to receive(:decode).and_return(decoded_jwt)
    end

    it 'returns the user data in a HashWithIndifferentAccess' do
      result = subject.decode(token)

      expect(result.class).to be(HashWithIndifferentAccess)
      expect(result.count).to eq(user_data.count)
      expect(result[:user_id]).to eq(user_data[:user_id])
    end
  end
end
