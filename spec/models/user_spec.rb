require 'spec_helper'
require_relative './shared_examples'

describe User, type: :model do
  it_behaves_like :serializable_record

  describe 'callbacks' do
    it { is_expected.to callback(:set_auth_token).before(:create) }
  end

  describe 'associations' do
    it { is_expected.to have_many :posts }
  end

  describe 'validations' do
    it { is_expected.to have_secure_password }

    describe 'name' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_length_of :name }
    end

    describe 'email' do
      it { is_expected.to validate_presence_of :email }
      it { is_expected.to validate_length_of :email }
      it do
        is_expected.to(
          validate_uniqueness_of(:email).ignoring_case_sensitivity
        )
      end
      it_behaves_like :a_format_validator, :email, 'me@example.com', 'me_at_example.com'
    end

    describe 'phone number' do
      it { is_expected.to validate_uniqueness_of(:phone_number).allow_blank }
      it { is_expected.to validate_length_of :phone_number }
      it_behaves_like :a_format_validator, :phone_number, '1234567890', '123456789X'
    end
  end

  describe '#update_auth_token!' do
    let(:old_token) { Faker::Internet.device_token }
    let(:new_token) { Faker::Internet.device_token }
    let(:user) { create(:user, auth_token: old_token) }

    before do
      allow(SecureRandom).to receive(:hex).and_return(new_token)
    end

    it "rotates the user's private auth token" do
      expect(user.auth_token).to eq(old_token)
      user.update_auth_token!
      expect(user.auth_token).to eq(new_token)
    end
  end
end
