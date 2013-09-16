express = require 'express'
Router = express.Router
noop () = true

exports.create router (routes) =
    router = @new Router

    obj = {}
    for each @(route) in (routes)
        router.route('get', route.pattern, noop)

    recognise (path) =
        router.match('get', path, 0)
