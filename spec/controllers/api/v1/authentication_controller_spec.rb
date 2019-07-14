require 'spec_helper'
require_relative './shared_examples'

describe Api::V1::AuthenticationController, type: :controller do
  describe 'POST #authenticate' do
    let(:user) { create(:user) }
    let(:params) { { email: user.email, password: user.password } }
    let(:token) { Faker::Internet.device_token }
    let(:jwt_response) { { token: token }.to_json }

    context 'when the credentials are present and correct' do
      before do
        allow_any_instance_of(UserAuth)
          .to receive(:authenticate).and_return(token)

        post :authenticate, params: params
      end

      it { is_expected.to respond_with :ok }

      it 'returns JSON containing a JWT' do
        expect(response.body).to eq(jwt_response)
      end
    end

    context 'when the credentials are absent or incorrect' do
      before do
        allow_any_instance_of(UserAuth).to(
          receive(:authenticate)
          .and_raise(UserAuth::AuthenticationError)
        )

        post :authenticate, params: params
      end

      it_behaves_like :responds_401
    end
  end
end
