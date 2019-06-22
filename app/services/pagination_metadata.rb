class PaginationMetadata
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = WillPaginate.per_page

  def initialize(request, resource)
    @total_pages = resource.total_pages
    @total_entries = resource.total_entries
    @url = request.url
    @base_url = request.base_url
    @path = request.path
    @per_page = request.params[:per_page]&.to_i || DEFAULT_PER_PAGE
    @page = request.params[:page]&.to_i || DEFAULT_PAGE
  end

  def perform
    {
      meta: meta,
      links: links
    }
  end

  private

  attr_reader :total_pages, :total_entries, :per_page, :page, :url, :base_url, :path

  def first_page?
    page == 1
  end

  def last_page?
    page == total_pages
  end

  def links
    {}.tap do |hash|
      hash[:first] = generate_url unless first_page?
      hash[:prev] = generate_url(page - 1) unless first_page?
      hash[:self] = url
      hash[:next] = generate_url(page + 1) unless last_page?
      hash[:last] = generate_url(total_pages) unless last_page?
    end
  end

  def generate_url(page_number = DEFAULT_PAGE)
    "#{base_url + path}?page=#{page_number}&per_page=#{per_page}"
  end

  def meta
    {
      total: total_entries,
      pages: total_pages
    }
  end
end
