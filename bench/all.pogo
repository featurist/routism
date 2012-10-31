routes = [
  { pattern = "/", route = 'a' }
  { pattern = "/foo/bar", route = 'b' }
  { pattern = "/foo/:id", route = 'c' }
  { pattern = "/foo/:id/bar/:id", route = 'd' }
]

router names = ['choreographer', 'dispatch', 'barista', 'routism']

exports.compare = {}

define comparison (router, name) =
  comparison () =
    router "/"
    router "/foo/123"
    router "/foo/123/bar/456"
    router "/foo/bar"
    router "/foo/bar/baz"
    router "/something"

  exports.compare.(name) = comparison

for each @(name) in (router names)
  router = require("./#(name)").create router (routes)
  define comparison (router, name)
  
require("bench").run main()