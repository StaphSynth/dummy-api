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
  let(:auth_token) { Faker::Internet.device_token }
  let(:auth_token_2) { Faker::Internet.device_token }
  let(:user_password) { Faker::Internet.password }
  let(:user) do
    create(:user, auth_token: auth_token, password: user_password)
  end
  let(:user_email) { user.email }
  let(:params) { { email: user_email, password: user_password } }
  let(:jwt) { Faker::Internet.device_token }
  let(:headers) { { authorization: jwt } }
  let(:request) { double(params: params, headers: headers) }
  let(:json_web_token) { class_double(JsonWebToken) }

  subject { described_class.new(request) }

  describe '#authenticate' do
    before do
      allow(SecureRandom).to receive(:hex).and_return(auth_token_2)
    end

    describe 'when the user creds are valid' do
      it 'calls JsonWebToken.encode' do
        expect(JsonWebToken).to receive(:encode)

        subject.authenticate
      end

      it 'rotates the user auth token and passes it to .encode' do
        expect(user.auth_token).to eq(auth_token)
        expect(JsonWebToken).to receive(:encode).with({
          user_id: user.id,
          auth_token: auth_token_2
        })

        subject.authenticate
      end
    end

    describe 'when the user creds are invalid' do
      context 'non-existant user' do
        let(:user_email) { 'derp@derp.io' }

        it_behaves_like :raises_authentication_error
      end

      context 'wrong password' do
        before { user.update(password: 'new_password') }

        it_behaves_like :raises_authentication_error
      end
    end

    describe 'when the private user auth token rotation fails' do
      before do
        allow_any_instance_of(User)
          .to receive(:update_auth_token!).and_return(false)
      end

      it_behaves_like :raises_authentication_error
    end
  end

  describe '#authorize' do
    let(:user_id) { user.id }
    let(:decoded_jwt) { { user_id: user_id, auth_token: auth_token } }

    context 'when everything is fine' do
      before do
        allow(JsonWebToken).to receive(:decode).and_return(decoded_jwt)
      end

      it 'returns the user' do
        expect(subject.authorize).to eq(user)
      end
    end

    context "when the user doesn't exist" do
      let(:user_id) { 99999 }

      before do
        allow(JsonWebToken).to receive(:decode).and_return(decoded_jwt)
      end

      it_behaves_like :raises_authorization_error
    end

    context "when the user's private auth token is invalid" do
      let(:auth_token) { 'derp' }

      it_behaves_like :raises_authorization_error
    end

    context 'when the JWT has expired or is otherwise malformed' do
      before do
        allow(JsonWebToken).to receive(:decode).and_raise(JWT::DecodeError)
      end

      it_behaves_like :raises_authorization_error
    end

    context 'when the JWT is absent from the request' do
      let(:headers) { {} }

      it_behaves_like :raises_authorization_error
    end
  end
end
