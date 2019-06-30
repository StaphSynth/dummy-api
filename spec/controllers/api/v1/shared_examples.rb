shared_examples :a_paginated_index do |model|
  before { get :index }

  it { is_expected.to respond_with :ok }

  describe 'response headers' do
    it 'responds with JSON' do
      expect(response.content_type).to eq('application/json')
    end
  end

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
          create_list(model, total_items)
          get :index, params: { per_page: per_page }
        end

        it "responds with a paginated list of #{model}s" do
          results = JSON.parse(response.body)['data']

          expect(results.count).to eq(per_page)
          results.each do |result|
            expect(result['type']).to eq(model.to_s)
          end
        end

        it 'responds with links to other pages of results' do
          results = JSON.parse(response.body)['links']
          url = "/api/v1/#{model}s?page="

          expect(results['next']).to include(url)
          expect(results['last']).to include(url)
        end

        it "responds with meta data about the total number of #{model}s" do
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
