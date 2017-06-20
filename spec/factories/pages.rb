FactoryGirl.define do
  test_data = {
    url: 'http://www.example.com',
    h1: ['header1'],
    h2: ['header2'],
    h3: ['header3'],
    links: %w[http://www.link1.com]
  }.to_json

  factory :page do
    url 'http://www.example.com'
    chksum '2046768222'
    parsed test_data
  end
end
