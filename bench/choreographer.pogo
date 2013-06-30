router = require('choreographer').router
noop () = true

exports.create router (routes) =
    obj = {}
    for each @(route) in (routes)
        obj.(route.pattern.replace(r/:[^\/+]/, '*')) = noop
    
    router := router (obj)    
    
    recognise (path) =
        req = { url = path, method = 'GET' }
        res = { write head = noop, end = noop }
        router (req, res, noop)
