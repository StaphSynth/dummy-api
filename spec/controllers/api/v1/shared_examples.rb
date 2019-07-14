shared_examples :a_get_endpoint do
  describe 'response headers' do
    it { is_expected.to respond_with :ok }

    it 'responds with JSON' do
      expect(response.content_type).to eq('application/json')
    end
  end
end

shared_examples :a_paginated_index do |resource|
  before { get :index }

  it_behaves_like :a_get_endpoint

  describe 'response body' do
    describe 'the shape of the response' do
      it 'responds with the appropriate structure' do
        result = JSON.parse(response.body)

        expect(result.count).to eq(3)
        %w(data links meta).each do |key|
          expect(result).to include(key)
        end
      end

      describe 'content of the response' do
        let(:total_items) { 10 }
        let(:per_page) { 5 }

        before do
          create_list(resource, total_items)
          get :index, params: { per_page: per_page }
        end

        it "responds with a paginated list of #{resource}s" do
          results = JSON.parse(response.body)['data']

          expect(results.count).to eq(per_page)
          results.each do |result|
            expect(result['type']).to eq(resource.to_s)
          end
        end

        it 'responds with links to other pages of results' do
          results = JSON.parse(response.body)['links']
          url = "/api/v1/#{resource}s?page="

          expect(results['next']).to include(url)
          expect(results['last']).to include(url)
        end

        it "responds with meta data about the total number of #{resource}s" do
          results = JSON.parse(response.body)['meta']
          mock_results = {
            'total' => total_items,
            'pages' => total_items / per_page
          }

          expect(results).to eq(mock_results)
        end
      end
    end
  end
end

shared_examples :a_show_endpoint do |resource|
  before do
    create(resource, id: 1)
    get :show, params: { id: 1 }
  end

  it_behaves_like :a_get_endpoint

  describe 'response body' do
    subject { JSON.parse(response.body) }

    describe 'the shape of the response' do
      it 'responds with the approprite structure' do
        expect(subject.count).to eq(1)
        expect(subject['data']).to be
      end
    end

    describe 'the content of the response' do
      it 'returns the resource type' do
        expect(subject['data']['type']).to eq(resource.to_s)
      end

      it "returns the resource's attributes and relationships" do
        %w(attributes relationships).each do |content|
          expect(subject['data'][content]).to be
        end
      end
    end
  end
end

shared_examples :responds_401 do
  describe 'when the controller responds 401' do

    it { is_expected.to respond_with :unauthorized }

    it 'returns JSON describing the error' do
      output = JSON.parse(response.body)
      expected = %w(error status)

      output.each do |key, _value|
        expect(expected).to include(key)
      end
    end
  end
end
