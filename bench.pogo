url = require('url')

dispatch = require 'dispatch'
noop () = true
dispatch router = dispatch {
  '/' = noop
  '/foo/bar' = noop
  '/foo/:id' = noop
  '/foo/:id/bar/:another' = noop
}  

Barista Router = require('barista').Router
barista router = new (Barista Router)
barista router.get("/").to("home.index")
barista router.get("/foo/bar").to("foo.bar")
barista router.get("/foo/:id").to("foo.id")
barista router.get("/foo/:id/bar/:another").to("bar.id")

choreographer router = require('choreographer').router

routes = [
  { pattern = "/", route = 'home' }
  { pattern = "/foo/bar", route = 'foo bar' }
  { pattern = "/foo/:id", route = 'foo by id' }
  { pattern = "/foo/:id/bar/:id", route = 'bar by id' }
]

routism router = require('./src/routism').compile (routes)

widget url = "http://foo.com/widgets/123"

req = { url = widget url, method = 'GET', parsed url = url.parse(widget url) }
res = { }

exports.compare = {
  routism  () = routism router.recognise "/widgets/123"
  dispatch () = dispatch router (req, res, noop)
  barista  () = barista router.first('/widgets/123', 'GET')
  choreographer () = choreographer router(req, res, noop)
}
require("bench").run main()