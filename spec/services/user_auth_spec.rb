require 'spec_helper'

shared_examples :raises_authorization_error do
  it 'raises a UserAuth::AuthorizationError' do
    expect{ subject.authorize }
      .to raise_error(UserAuth::AuthorizationError)
  end
end

shared_examples :raises_authentication_error do
  it 'raises a UserAuth::AuthenticationError' do
    expect{ subject.authenticate }
      .to raise_error(UserAuth::AuthenticationError)
  end
end

describe UserAuth, type: :service do
  let(:user) { create(:user) }
  let(:params) { { email: user.email, password: user.password } }
  let(:token) { Faker::Internet.device_token }
  let(:headers) { { authorization: token } }
  let(:request) { double(params: params, headers: headers) }
  let(:json_web_token) { class_double(JsonWebToken) }

  subject { described_class.new(request) }

  describe '#authenticate'

  describe '#authorize' do
    let(:decoded_token) { { user_id: user.id } }

    context 'when everything is fine' do
      before do
        allow(JsonWebToken).to receive(:decode).and_return(decoded_token)
      end

      it 'returns the user' do
        expect(subject.authorize).to eq(user)
      end
    end

    context "when the user doesn't exist" do
      let(:decoded_token) { { user_id: 9999 } }

      before do
        allow(JsonWebToken).to receive(:decode).and_return(decoded_token)
      end

      it_behaves_like :raises_authorization_error
    end

    context 'when the token has expired or is otherwise malformed' do
      before do
        allow(JsonWebToken).to receive(:decode).and_raise(JWT::DecodeError)
      end

      it_behaves_like :raises_authorization_error
    end

    context 'when the token is absent from the request' do
      let(:headers) { {} }

      it_behaves_like :raises_authorization_error
    end
  end
end
