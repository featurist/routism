routes = [
    { pattern = "/", route = 'a' }
    { pattern = "/foo/bar", route = 'b' }
    { pattern = "/foo/:id", route = 'c' }
    { pattern = "/foo/:id/bar/:id", route = 'd' }
    { pattern = "/foo/:a/bar/:b/baz/:c/wow/:d/omg/:e/rofl", route = 'e' }
    { pattern = "/zzz/omg", route = 'f' }
    { pattern = "/x/y/z", route = 'g' }
    { pattern = "/x/z/:y", route = 'h' }
    { pattern = "/omg/wow", route = 'i' }
    { pattern = "/d/blah", route = 'j' }
    { pattern = "/happy/days", route = 'k' }
    { pattern = "/lots/of/:routes", route = 'l' }
    { pattern = "/i/see", route = 'm' }
]

router names = [ 'barista', 'choreographer', 'dispatch', 'express', 'page', 'routism']

exports.compare = {}

define comparison (router, name) =
    comparison () =
        router "/"
        router "/foo/123"
        router "/foo/123/bar/456"
        router "/foo/bar"
        router "/foo/bar/baz"
        router "/something"
        router "/foo/12/bar/34/baz/56/wow/78/omg/90/rofl"

    exports.compare.(name) = comparison

for each @(name) in (router names)
    router = require("./#(name)").create router (routes)
    define comparison (router, name)

require("bench").run main()