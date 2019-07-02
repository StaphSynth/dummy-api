require 'spec_helper'
require_relative './shared_examples'

describe PostSerializer, type: :serializer do
  let(:post) { create(:post) }
  post_attributes = %i[id title body created_at updated_at]

  subject { PostSerializer.new(post).serializable_hash }

  it_behaves_like :a_serializer, :post, post_attributes

  describe 'relationships' do
    subject do
      PostSerializer.new(post).serializable_hash[:data][:relationships]
    end

    it "lists the post's author" do
      result = subject[:user][:data]

      expect(result[:type]).to eq(:user)
      expect(result[:id]).to eq(post.user_id.to_s)
    end
  end
end
