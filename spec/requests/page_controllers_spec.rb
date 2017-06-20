require 'rails_helper'

RSpec.describe 'PageControllers', type: :request do
  describe 'GET /page' do
    it 'returns a set of parsed page urls' do
      FactoryGirl.create_list(:page, 5)
      get '/v1/page'
      json = JSON.parse(response.body)
      expect(response).to be_success
      expect(json.length).to eq(5)
    end
  end

  describe 'POST /page' do
    it 'fetches a url and stores its parsed data' do
      test_page = '
        <html>
          <body>
          <h1>header1</h1>
          <h2>header2</h2>
          <h3>header3</h3>
          <a href="http://www.link1.com"></a>
          </body>
        </html>
      '
      stub_request(:get, 'http://www.example.com')
        .to_return(status: 200, body: test_page)
      post '/v1/page', params: { url: 'http://www.example.com' }

      json = JSON.parse(response.body)
      test_data = FactoryGirl.build(:page)

      expect(response).to be_success
      expect(Page.count).to eq 1
      expect(json).to eq('parsed' => test_data[:parsed],
                         'url' => test_data[:url],
                         'chksum' => test_data[:chksum])
    end
  end

  describe 'POST /page fails with malformed url' do
    it 'returns 400 for BadRequest ' do
      post '/v1/page', params: { url: 'www.noprotocol.com' }
      expect(response).to be_a_bad_request
    end
  end

  describe 'POST /page fails with upstream error' do
    it 'returns 502 for Invalid response from upstream server' do
      stub_request(:get, 'http://www.inaccessible.com')
        .to_return(status: 503, body: 'somedata')

      post '/v1/page', params: { url: 'http://www.inaccessible.com' }
      json = JSON.parse(response.body)
      expect(json['message']).to include 'status: 503'
      expect(response.code).to eq '502'
    end
  end
end
