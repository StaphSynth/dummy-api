require 'spec_helper'
require_relative './shared_examples'

describe Post, type: :model do
  it_behaves_like :serializable_record

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end
end
