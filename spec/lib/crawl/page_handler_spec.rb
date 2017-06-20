require 'rails_helper'

describe Crawl::PageHandler do
  describe :fetch_page do
    it 'can fetch a valid url' do
      test_data = 'Website Data'
      stub_request(:get, 'http://www.example.com')
        .to_return(status: 200, body: test_data)
      result = Crawl::PageHandler.fetch_page('http://www.example.com')
      expect(result).to eq test_data
    end
    it 'throws exception for malformed url' do
      expect { Crawl::PageHandler.fetch_page('www.example.com') }
        .to raise_error(Error::WebError, 'Malformed URL www.example.com')
    end

    it 'throws exception for non 200 response' do
      stub_request(:get, 'http://www.example.com')
        .to_return(status: 503, body: 'system upstream failure')
      expect { Crawl::PageHandler.fetch_page('http://www.example.com') }
        .to raise_error(Error::WebError,
                        'Failed upstream request for http://www.example.com with status: 503')
    end
  end

  describe :parse_page do
    it 'can parse a webpage' do
      test_data = {
        h1: ['H1 - Header 1', 'H1 - Header 2'],
        h2: ['H2 - Header 1'],
        h3: ['H3 - Header 2'],
        links: ['http://www.example.com', 'http://www.example2.com'],
        url: 'http://www.example3.com'
      }
      test_page = %(
        <html>
          <body>
            <h1>#{test_data[:h1][0]}</h1>
            <h1>#{test_data[:h1][1]}</h1>
            <h2>#{test_data[:h2][0]}</h2>
            <h3>#{test_data[:h3][0]}</h3>
            <a href ="#{test_data[:links][0]}"> Example1</a>
            <a href ="#{test_data[:links][1]}"> Example2</a>
         </body>
         )
      test_result = Crawl::PageHandler
                    .parse_page('http://www.example3.com', test_page)
      expect(test_result).to eq test_data
    end
  end
end
