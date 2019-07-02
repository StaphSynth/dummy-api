require 'spec_helper'
require_relative './shared_examples'

describe Api::V1::PostsController, type: :controller do
  describe 'GET #index' do
    it_behaves_like :a_paginated_index, :post
  end

  describe 'GET #show' do
    it_behaves_like :a_show_endpoint, :post
  end
end
