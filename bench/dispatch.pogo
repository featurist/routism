dispatch = require 'dispatch'
noop () = true

exports.create router (routes) =
  obj = {}
  for each @(route) in (routes)
    obj.(route.pattern) = noop
  
  router = dispatch (obj)  
  
  recognise (path) =
    req = { url = path, method = 'GET' }
    res = {}
    router (req, res, noop)