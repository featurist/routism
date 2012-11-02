routism = require '../src/routism'
connect = require 'connect'
request = require 'request'

create router (route table) =
  routism.compile (route table)

say (what) =
  respond (req, res) =
    res.end (what)

echo param (n) =
  respond (req, res, next, params) =
    res.end (params.(n).1)

describe 'routism, wired up to connect'
  
  before @(done)
    connect router = create router([
      { pattern = "/hello/world", route = say "hello" }
      { pattern = "/params/:foo", route = echo param 0 }
    ]).connectify()
    app = connect()
    app.use (connect router)
    app.listen 80012
      done()
  
  it 'responds to requests' @(done)
    request 'http://127.0.0.1:80012/hello/world' @(err, res, body)
      body.should.equal 'hello'
      done()
  
  it 'sets request params' @(done)
    request 'http://127.0.0.1:80012/params/blah' @(err, res, body)
      body.should.equal 'blah'
      done()
