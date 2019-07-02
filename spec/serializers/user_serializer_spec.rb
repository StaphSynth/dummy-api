require 'spec_helper'
require_relative './shared_examples'

describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }
  user_attributes = %i[id name email phone_number created_at updated_at]

  subject { UserSerializer.new(user).serializable_hash }

  it_behaves_like :a_serializer, :user, user_attributes

  describe 'relationships' do
    let!(:post) { create(:post, user: user) }

    subject do
      UserSerializer.new(user).serializable_hash[:data][:relationships]
    end

    it "lists the user's posts" do
      result = subject[:posts][:data].first

      expect(result[:type]).to eq(:post)
      expect(result[:id]).to eq(post.id.to_s)
    end
  end
end
