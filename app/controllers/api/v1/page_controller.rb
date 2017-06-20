
module Api::V1
  # PageController handles page parsing and metadata request
  class PageController < ApplicationController
    # Get a list of all parsed page urls
    def index
      url = Page.select('url')
      render json: url.map(&:url)
    end

    # Create a new Parsed Page
    def create
      url = params['url']
      doc = Crawl::PageHandler.fetch_page(url)
      page_data = Crawl::PageHandler.parse_page(url, doc)
      page = Page.create(url: url,
                         chksum: Zlib.crc32(url),
                         parsed: page_data.to_json)
      render json: { url: page[:url],
                     chksum: page[:chksum],
                     parsed: page[:parsed] }
    end
  end
end
