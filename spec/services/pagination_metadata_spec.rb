require 'spec_helper'

describe PaginationMetadata, type: :service do
  let(:page) { 1 }
  let(:per_page) { 10 }
  let(:total_entries) { 30 }
  let(:total_pages) { (total_entries / per_page.to_f).ceil }
  let(:request) { instance_double(ActionDispatch::Request) }
  let(:paginated_resource) { double }
  let(:base_url) { 'https://example.com' }
  let(:path) { '/api/v1/posts.json' }
  let(:url) { base_url + path }
  let(:params) do
    {
      per_page: per_page.to_s,
      page: page.to_s
    }
  end

  subject do
    described_class.new(request, paginated_resource)
  end

  describe '#perform' do
    before do
      allow(WillPaginate).to receive(:per_page).and_return(per_page)
      allow(request).to receive(:url).and_return(url)
      allow(request).to receive(:base_url).and_return(base_url)
      allow(request).to receive(:path).and_return(path)
      allow(request).to receive(:params).and_return(params)
      allow(paginated_resource).to receive(:total_pages).and_return(total_pages)
      allow(paginated_resource).to receive(:total_entries).and_return(total_entries)
    end

    it 'returns a has with meta and links keys' do
      result = subject.perform

      expect(result).to be_a(Hash)
      expect(result.count).to eq(2)
      expect(result[:meta]).to be
      expect(result[:links]).to be
    end

    describe 'meta' do
      let(:meta) do
        {
          total: total_entries,
          pages: total_pages
        }
      end

      it 'contains a hash with resource totals' do
        expect(subject.perform[:meta]).to eq(meta)
      end
    end


    describe 'links' do
      let(:first_page) { "#{url}?page=1&per_page=#{per_page}" }
      let(:prev_page) { "#{url}?page=#{page - 1}&per_page=#{per_page}"}
      let(:next_page) { "#{url}?page=#{page + 1}&per_page=#{per_page}" }
      let(:last_page) { "#{url}?page=#{total_pages}&per_page=#{per_page}" }

      describe 'when there are many pages' do
        describe 'when on the first page' do
          let(:links) { subject.perform[:links] }

          it 'includes links for the next, last and self pages' do
            expect(links[:next]).to eq(next_page)
            expect(links[:last]).to eq(last_page)
            expect(links[:self]).to eq(url)
          end

          it 'does not include links for prev or first page' do
            expect(links[:prev]).to be_nil
            expect(links[:first]).to be_nil
          end
        end

        describe 'when on a middle page' do
          let(:page) { total_pages - 1 }
          let(:links) { subject.perform[:links] }

          it 'includes links for first, prev, self, next and last pages' do
            expect(links[:first]).to eq(first_page)
            expect(links[:prev]).to eq(prev_page)
            expect(links[:self]).to eq(url)
            expect(links[:next]).to eq(next_page)
            expect(links[:last]).to eq(last_page)
          end
        end

        describe 'when on the last page' do
          let(:page) { total_pages }
          let(:links) { subject.perform[:links] }

          it 'includes links for prev, first and self pages' do
            expect(links[:first]).to eq(first_page)
            expect(links[:prev]).to eq(prev_page)
            expect(links[:self]).to eq(url)
          end

          it 'does not include links for next or last page' do
            expect(links[:next]).to be_nil
            expect(links[:last]).to be_nil
          end
        end
      end

      describe 'when there is only one page' do
        let(:per_page) { total_entries }
        let(:links) { subject.perform[:links] }

        it 'provides a link to self' do
          expect(links[:self]).to eq(url)
        end

        it 'does not include any other page links' do
          expect(links[:first]).to be_nil
          expect(links[:prev]).to be_nil
          expect(links[:next]).to be_nil
          expect(links[:last]).to be_nil
        end
      end
    end
  end
end
