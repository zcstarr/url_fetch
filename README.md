# README

### Usage

UrlFetch: A simple rails api project that fetches a url, parses a webpage, and stores the result as a json text blob. In addition to storing the result, the service has a route that returns an array of urls that have been processed. As a note duplicate entries in the array means it has been processed multiple times, at different points in time.

### Get Started
```
git clone 
cd url_fetch
bundle 
rake db:migrate
rails s
curl -X POST -d "url=http://www.yahoo.com" http://localhost:3000/v1/page
curl -X GET http://localhost:3000/v1/page
```

# Page API 

## `POST /page`

Create a new parsed page.

* `Accept`: `"application/json"`

Include the `url` text in the body:

```
"url=http://www.example.com"
```

===

### Example Query
```
curl -i -d "url=www.example.com" -X POST http://localhost:3000/v1/page
```

### Example Response

* `Status`: `200`
* `Content-Type`: `"application/json"`

```
{
  "url": "http://www.example.com",
  "chksum": "Mat", //url chksum
  "parsed": \"{h1:["header1 data",...], h2: ["header2 data,...], h3: ["header3 data",...],
               links: ["http://www.example.com", "/home"], url: http://www.example.com}\" 
               //a json string of parsed data
}

```
### Example Error Responses
* `Status`: `400`
* `Content-Type`: `"application/json"`

```
{
   "message":"Malformed URL www.example.com", //missing uri scheme "http://" or "https://"
   "error":"StandardError"
}
```

* `Status`: `502`
* `Content-Type`: `"application/json"`

```
{
   "message":"Failed upstream request for www.somethingbadfailure.com with status: 503","
   "error":"StandardError"
}
```

## `GET /page`

Get list of parsed page urls.

===

### Example query
```
curl -X GET http://localhost:3000/v1/page
```
### Example response

* `Status`: `200`
* `Content-Type`: `"application/json"`

```
{
  "url": "http://www.example.com",
  "chksum": "Mat", //url chksum
  "parsed": \"{h1:["header1 data",...], h2: ["header2 data,...], h3: ["header3 data",...],
               links: ["http://www.example.com", "/home"], url: http://www.example.com}\" 
               //a json string of parsed data
}
```
