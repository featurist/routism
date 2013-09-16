global.window = { location = { pathname = '/' } }
global.document = { }
global.history = { pushState () = @{} }
global.addEventListener () = @{}
global.removeEventListener () = @{}

page = require 'page'
noop () = true

exports.create router (routes) =
    for each @(route) in (routes)
        page(route.pattern, noop)

    recognise (path) =
        page (path)
