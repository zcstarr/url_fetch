module Crawl
  # PageHandler class handles fetching and parsing webpages
  # it requires uri scheme to be specified http://
  class PageHandler
    # fetch_page takes a uri scheme specified url and returns the body
    # of the request
    def self.fetch_page(url)
      if url !~ URI.regexp
        raise Error::WebError.new("Malformed URL #{url}", :StandardError, 400)
      end
      response = nil
      begin
        response = RestClient.get(url)
      rescue RestClient::ExceptionWithResponse => err
        response = err.response
      end
      code = response.code.to_i
      if code < 200 || code > 300
        raise Error::WebError.new(
          "Failed upstream request for #{url} with status: #{code}",
          :WebError,
          502
        )
      end
      response.body
    end

    # parse_page takes a raw string and returns a parsed hash
    def self.parse_page(url, doc_string)
      doc = Nokogiri::HTML(doc_string)
      tags = %w[h1 h2 h3].map do |tag_name|
        doc.css(tag_name).map(&:inner_text)
      end
      links = doc.css('a').map { |link| link['href'] }
      { url: url, h1: tags[0], h2: tags[1], h3: tags[2], links: links }
    end
  end
end
