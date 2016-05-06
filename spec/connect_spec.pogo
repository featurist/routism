routism = require '../src/routism'
connect = require 'connect'
request = require 'request'
url = require 'url'

say (what) =
  respond (req, res) =
    res.end (what)

echo param (n) =
  respond (req, res, next, params) =
    res.end (params.(n).1)

connectify (compliedRoutes) =
  handle (req, res, next) =
    path = url.parse(req.url).pathname
    match = compliedRoutes.recognise(path)
    if (match)
      match.route(req, res, next, match.params)
    else
      next()

describe 'routism, wired up to connect'

  before @(done)
    compiledRoutes = routism.compile [
      { pattern = "/hello/world", route = say "hello" }
      { pattern = "/params/:foo", route = echo param 0 }
    ]
    connectRouter = connectify(compiledRoutes)
    app = connect()
    app.use (connectRouter)
    app.listen 8012
      done()

  it 'responds to requests' @(done)
    request 'http://127.0.0.1:8012/hello/world' @(err, res, body)
      body.should.equal 'hello'
      done()

  it 'sets request params' @(done)
    request 'http://127.0.0.1:8012/params/blah' @(err, res, body)
      body.should.equal 'blah'
      done()
