require 'spec_helper'
require_relative './shared_examples'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    it_behaves_like :a_paginated_index, :user
  end
end
