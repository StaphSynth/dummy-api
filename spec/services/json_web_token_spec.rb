require 'spec_helper'

describe JsonWebToken, type: :service do
  let(:payload) { { user_id: 1, auth_token: 'open_sesame' } }

  describe '.encode' do
    let(:time) { Time.now }
    let(:secret) { 'shhh_secret' }

    before do
      allow(Time).to receive(:now).and_return(time)
      allow(Rails.application.secrets)
        .to receive(:secret_key_base).and_return(secret)
    end

    it 'returns a JWT' do
      expect(subject.encode(payload)).to include('eyJhbGciOiJIUzI1NiJ9')
    end

    describe 'when only the payload is passed' do
      let(:expected) do
        payload[:exp] = time
        payload[:iat] = time
        payload
      end

      before do
        allow(1.day).to receive(:from_now).and_return(time)
      end

      it 'passes the appropriate data to JWT.encode' do
        expect(JWT).to receive(:encode).with(expected, secret)
        subject.encode(payload)
      end
    end

    describe 'when an optional expiry param is passed' do
      let(:optional_exp) { 2.hours.from_now }
      let(:expected) do
        payload[:exp] = optional_exp
        payload[:iat] = time
        payload
      end

      it 'adds that value to the payload in place of defult exp' do
        expect(JWT).to receive(:encode).with(expected, secret)
        subject.encode(payload, optional_exp)
      end
    end
  end

  describe '.decode' do
    let(:jwt) { Faker::Internet.device_token }
    let(:decoded_jwt) { [payload, { meta_data: 'meta data' }] }

    before do
      allow(JWT).to receive(:decode).and_return(decoded_jwt)
    end

    it 'returns the user data in a HashWithIndifferentAccess' do
      result = subject.decode(jwt)

      expect(result.class).to be(HashWithIndifferentAccess)
      expect(result.count).to eq(payload.count)
      expect(result[:user_id]).to eq(payload[:user_id])
    end
  end
end
