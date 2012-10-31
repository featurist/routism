Router = require('barista').Router

exports.create router (routes) =
  router = new (Router)
  for each @(route) in (routes)
    router.get(route.pattern, "controller.action")
  
  recognise (path) =
    router.first(path, "GET")